load('filtered_frames.mat','filtered_frames');
hold on
for i = 1:20:3000
    plot([i,i],[3,2],'r-');
end
for i = 1:150
    plot([filtered_frames(i),filtered_frames(i)],[1,0],'r-');
end
hold off