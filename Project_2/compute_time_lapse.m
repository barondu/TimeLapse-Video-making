close all;
clear;
% parameters for frame selection
n_out = 5; % number of output_frames
k_frames = 100; % number of input_frame
k_itr = 20; % number of iterations

% parameters that controls virtural shutter
mu = 30;
zeta = 0.90;

filtered_frames = zeros(n_out*k_itr,1);

%% extra key frames
for i = 1:k_itr
    start_index = (i-1)*k_frames;
    end_index = k_frames*i-1;
    RawFrames = load_sequence_color('./whales','whales', start_index, end_index, 4, 'jpg');
    filtered_frames((i-1)*n_out+1:i*n_out) = select_key_frames(RawFrames,start_index,n_out);
    test=1;
end

%% build virtual shutter frames between each section
result_frames = zeros(360,360,3,n_out*k_itr);
result_frames(:,:,:,1) = load_sequence_color('./whales','whales', 0, 0, 4, 'jpg');
for i = 2:n_out*k_itr
    last_index = filtered_frames(i-1);
    current_index = filtered_frames(i);
    ref_frame = result_frames(:,:,:,i-1);
    result_frames(:,:,:,i)= compute_weighting_virtual_shutter_frame(last_index,current_index,ref_frame,mu,zeta);    
end

%% save as video frames
save_sequence(result_frames, './result_frames', 'result_', 0, 4);

%% Export result images/video
name = 'whales';
filename = ['result_video/' name '.avi'];
v = VideoWriter(filename,'Uncompressed AVI');
open(v) ;
out_frame = load_sequence_color('./result_frames','result_', 0, n_out*k_itr-1, 4, 'jpg');
for k=1:n_out*k_itr
    writeVideo(v,out_frame(:,:,:,k)) ;
end
close(v);