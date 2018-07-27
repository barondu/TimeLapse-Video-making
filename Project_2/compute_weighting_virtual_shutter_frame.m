function [ result_frame ] = compute_weighting_virtual_shutter_frame( last_index,current_index,ref_frame,mu,zeta)

   % load frames between current and last index
   frames = load_sequence_color('./whales','whales', last_index, current_index, 4, 'jpg');
   % replaces the first frame with result frame of last shutter
   frames(:,:,:,1) = ref_frame;
   
   [m,n,d,nframes] = size(frames);
   result_frame = zeros(m,n,d);
   
   for i=1:m
       for j=1:n
           % compute the RGB sum of the pixel at each channel in this
           % exposure period
           RGB_sum = sum(frames(i,j,:,:),4);
           % get the RGB value of current frame
           vz = frames(i,j,:,end);
           
           f = [-1:-1:-nframes]';
           % compute the weight of samples based on its time distance to current frames 
           weight = compute_weight(zeta,mu,vz,f,RGB_sum);
           
           result_frame(i,j,1) = compute_weighed_pixel(weight(:,:,1),frames(i,j,1,:),nframes);
           
           result_frame(i,j,2) = compute_weighed_pixel(weight(:,:,2),frames(i,j,2,:),nframes);
           
           result_frame(i,j,3) = compute_weighed_pixel(weight(:,:,3),frames(i,j,3,:),nframes);
       end
   end
   
end

% placing less weight on the more recent samples
function weight = compute_weight(zeta,mu,vz,f,vsum)
    kappa = (f+vz).*mu./(vz-vsum);
    weight = zeta.^kappa;
end

function pixel_val = compute_weighed_pixel(weight,pixel_array,nframes)
    % normalize factor
    weight_sum = sum(weight,1);
    % weight pixel values
    weighted_val_sum = reshape(weight,[1,nframes])*reshape(pixel_array,[nframes,1]);
    % normalize the weighted sum of the pixel by its weights
    pixel_val = weighted_val_sum/weight_sum;
end

