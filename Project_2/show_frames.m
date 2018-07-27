function [] = show_frames( frames_index )
    nframes = size(frames_index,1);
    for i=1:nframes
        imshow(load_sequence_color('./whales','whales', frames_index(i), frames_index(i), 4, 'jpg'));
    end

end

