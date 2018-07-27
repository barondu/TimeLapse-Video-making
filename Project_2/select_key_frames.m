function [ filtered_frames ] = select_key_frames(frames,start_index,n_out)
    
    [~,~,~,nframes] = size(frames);    
    distMatrix = zeros(nframes,nframes);
    
    row_distance = zeros(nframes,1);
    
    % compute the distance matrix of frames
    for i = 1:nframes
        src_frame = frames(:,:,:,i);
        weight_sum = 0;
        for j = 1:nframes
            if i == j
                distMatrix(i,j)=0;
                continue;
            end
                       
            target_frame = frames(:,:,:,j);
            
            distance = compute_RGB_distance(src_frame,target_frame);
            [weight,weighted_distance] = compute_penalty_weigth(distance,i,j,nframes);
            
            distMatrix(i,j) = weighted_distance;
            weight_sum = weight_sum+weight;
        end
        row = distMatrix(i,:);
        row_distance(i) =sum(row)/weight_sum; 
    end
    
    % peak the n highest peak in the row-wise distance map
    [~,peakLocs]=findpeaks(row_distance,'sortstr','descend');
    p = peakLocs(1:n_out);
    p = sort(p,'ascend');
    % sotre the index of selected frames
    filtered_frames = p+(start_index-1);


end

function [weight,weighted_distance] = compute_penalty_weigth(distance,i,j,nframes)
    weight = abs((j-i)/nframes);
    weighted_distance = distance*weight;
end

