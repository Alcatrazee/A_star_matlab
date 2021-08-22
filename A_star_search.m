function [path,OPEN] = A_star_search(map,MAX_X,MAX_Y,heuristic_weight,path_cost_weight)
%%
%This part is about map/obstacle/and other settings
%pre-process the grid map, add offset
size_map = size(map,1);
Y_offset = 0;
X_offset = 0;

%Define the 2D grid map array.
%Obstacle=-1, Target = 0, Start=1
MAP=2*(ones(MAX_X,MAX_Y));

%Initialize MAP with location of the target
xval=floor(map(size_map, 1)) + X_offset;
yval=floor(map(size_map, 2)) + Y_offset;
xTarget=xval;
yTarget=yval;
MAP(xval,yval)=0;

%Initialize MAP with location of the obstacle
for i = 2: size_map-1
    xval=floor(map(i, 1)) + X_offset;
    yval=floor(map(i, 2)) + Y_offset;
    MAP(xval,yval)=-1;
end

%Initialize MAP with location of the start point
xval=floor(map(1, 1)) + X_offset;
yval=floor(map(1, 2)) + Y_offset;
xStart=xval;
yStart=yval;
MAP(xval,yval)=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LISTS USED FOR ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OPEN LIST STRUCTURE
%--------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Parent X val |Parent Y val |h(n) |g(n)|f(n)|
%--------------------------------------------------------------------------
OPEN=[];
%CLOSED LIST STRUCTURE
%--------------
%X val | Y val |
%--------------
% CLOSED=zeros(MAX_VAL,2);
CLOSED=zeros(size_map-1,2);

%Put all obstacles on the Closed list
k=1;%Dummy counter
for i=1:MAX_X
    for j=1:MAX_Y
        if(MAP(i,j) == -1)
            CLOSED(k,1)=i;
            CLOSED(k,2)=j;
            k=k+1;
        end
    end
end
CLOSED_COUNT=size(CLOSED,1);
%set the starting node as the first node
xNode=xval;
yNode=yval;
OPEN_COUNT=1;
goal_distance=distance(xNode,yNode,xTarget,yTarget);
path_cost=0;
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,xNode,yNode,goal_distance,path_cost,goal_distance);
OPEN(OPEN_COUNT,1)=1;
% CLOSED_COUNT=CLOSED_COUNT+1;
% CLOSED(CLOSED_COUNT,1)=xNode;
% CLOSED(CLOSED_COUNT,2)=yNode;
NoPath=1;

%%
%This part is your homework
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% heuristic_weight = 1;
% path_cost_weight = 1;
while ~(sum(OPEN(:,1))==0)    %you have to dicide the Conditions for while loop exit
    %
    %finish the while loop
    %
    index = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget);
    if index == -1
        NoPath = 1;
        disp('no solution')
        break ;
    end
    node_to_expend = OPEN(index,:);
    OPEN(index,1) = 0;
    CLOSED_COUNT = CLOSED_COUNT + 1;
    CLOSED(CLOSED_COUNT,:) = [node_to_expend(2),node_to_expend(3)];
    if ~(node_to_expend(2) == xTarget && node_to_expend(3) == yTarget)
        for i = -1:1
            for j = -1:1
                if ~(i==0 && j==0)
                    node_coor = [node_to_expend(2)+i node_to_expend(3)+j];
                    if node_coor(1)>0 && node_coor(1) <= MAX_X && node_coor(2) >0 && node_coor(2) <= MAX_Y
                        exist_in_closed = exist_in_close(CLOSED, node_coor(1),node_coor(2));
                        exist_in_opened = exist_in_close(OPEN(:,2:3), node_coor(1),node_coor(2));
                        if ~exist_in_closed
                            if (i == -1 && j == -1)||(i == -1 && j == 1)||(i == 1 && j == -1)||(i == 1 && j == 1)
                                path_cost = node_to_expend(7) + 1.4142;
                            else
                                path_cost = node_to_expend(7) + 1;
                            end
                            if ~exist_in_opened         % means g(m) = inf
                                h_n = distance(node_coor(1),node_coor(2),xTarget,yTarget);
                                OPEN(OPEN_COUNT+1,:) = insert_open(node_coor(1),node_coor(2),node_to_expend(2),node_to_expend(3),h_n,path_cost,heuristic_weight*h_n+path_cost_weight*path_cost);
                                OPEN_COUNT = OPEN_COUNT + 1;
                            else
                                index_in_open = node_index(OPEN,node_coor(1),node_coor(2));
                                if path_cost < OPEN(index_in_open,7)
                                    OPEN(index_in_open,4) = node_to_expend(2);
                                    OPEN(index_in_open,5) = node_to_expend(3);
                                    OPEN(index_in_open,7) = path_cost;
                                    OPEN(index_in_open,8) = heuristic_weight*h_n+path_cost_weight*path_cost;
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        NoPath = 0;
        break;
    end
end %End of While Loop

%Once algorithm has run The optimal path is generated by starting of at the
%last node(if it is the target node) and then identifying its parent node
%until it reaches the start node.This is the optimal path

%
%How to get the optimal path after A_star search?
%please finish it
%
if NoPath == 0
    path = [];
    index_of_current_node = node_index(OPEN,xTarget,yTarget);
    path = [path;OPEN(index_of_current_node,2) OPEN(index_of_current_node,3)];
    parent_xy = OPEN(index_of_current_node,4:5);
    current_node = [xTarget,yTarget];
    while ~isequal(current_node,[xStart yStart])
        index_of_current_node = node_index(OPEN,parent_xy(1),parent_xy(2));
        path = [path;OPEN(index_of_current_node,2) OPEN(index_of_current_node,3)];
        parent_xy = OPEN(index_of_current_node,4:5);
        current_node = OPEN(index_of_current_node,2:3);
    end
else
    path = [];
    disp('no path can be found');
end
end
