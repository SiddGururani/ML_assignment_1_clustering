function [ class, centroid ] = mykmeans( pixels, K )
%
% Your goal of this assignment is implementing your own K-means.
%
% Input:
%     pixels: data set. Each row contains one data point. For image
%     dataset, it contains 3 columns, each column corresponding to Red,
%     Green, and Blue component.
%
%     K: the number of desired clusters. Too high value of K may result in
%     empty cluster error. Then, you need to reduce it.
%
% Output:
%     class: the class assignment of each data point in pixels. The
%     assignment should be 1, 2, 3, etc. For K = 5, for example, each cell
%     of class should be either 1, 2, 3, 4, or 5. The output should be a
%     column vector with size(pixels, 1) elements.
%
%     centroid: the location of K centroids in your result. With images,
%     each centroid corresponds to the representative color of each
%     cluster. The output should be a matrix with size(pixels, 1) rows and
%     3 columns. The range of values should be [0, 255].
%     
%
% You may run the following line, then you can see what should be done.
% For submission, you need to code your own implementation without using
% the kmeans matlab function directly. That is, you need to comment it out.

%	[class, centroid] = kmedoids(pixels, K);
%% implementation of K-means

CostFn = 100000;
max_iter = 200;
N = numel(pixels(:,1));

if K>N
    error('Number of clusters greater than number of pixels. Will not proceed.');
end

%% assigning random centroids for the K clusters.
c_idx = randsample(N,K);
c = pixels(c_idx,:);

%% Assigning first K points as centroids.
% c = pixels(1:K,:);

%% Sampling K points based on heuristic explained in the report.

% sum_points = sum(pixels,2);
% temp_pixels = [pixels sum_points];
% [~,d] = sort(temp_pixels(:,4));
% temp_pixels = temp_pixels(d,:);
% ind = [1:floor(size(pixels,1)/K):size(pixels,1)];
% c = temp_pixels(ind,1:3);

%% Clustering part of the algorithm

for iteration = 1:max_iter
    distances = pdist2(pixels, c, 'euclidean');
    %reassigning clusters based on minimum distance between point and
    %centroid. min_dist stores the distance which is used to compute the
    %new cost function.
    [min_dist, cluster] = min(distances,[],2);
    CostFn2 = mean(min_dist);
    if(CostFn2 == CostFn)c
        break;
    end
    CostFn = CostFn2;
    %recomputing centroids for each cluster
    for i = 1:K
% Handling empty clusters        
        if(isempty(find(cluster==i)) == 1)
            display('K-means: Empty cluster found. Assigning random point as centroid.');
            flag = 0;
            while flag == 0
                c_idx = randsample(N,1);
                c(i,:) = pixels(c_idx,:);
                if(size(unique(c,'rows'),1) == size(c,1))
                    flag = 1;
                end
            end
%             i = i-1;
%             c(i,:) = [];
%             K = K-1;
            continue;
        end
        c(i,:) = mean(pixels(find(cluster == i),:),1);
    end
end
%iteration
%CostFn
class = cluster;
centroid = c;
end
