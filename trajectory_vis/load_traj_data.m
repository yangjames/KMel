function traj_data = load_traj_data(varargin)

if nargin == 1 %load new trajectory
    traj_name = varargin{1};
    data = load(['trajectories/', traj_name]);
    %data.s = rmfield(data.s, 'vel'); %remove initial velocity field
    s = data.s;
    for i=1:length(s)
        %s(i).vel=(s(i).pos(:,2:end)-s(i).pos(:,1:end-1))/s(i).delT;
        s(i).a=(s(i).vel(:,2:end)-s(i).vel(:,1:end-1))/s(i).delT;
        s(i).cyl_flag =0;
    end
    %make sure the cylinder flags are all off
    for i=1:length(s)
        s(i).cyl_flag = 0;
    end
    
   traj_data=s;
elseif nargin == 2 %update an existing trajectory
    s = varargin{1};
    new_delT = varargin{2};
    %calculate new timer
    if ~isempty(s)
        new_timer = zeros(1, length(s(1).timer));
        for i=1:length(s(1).timer)
            new_timer(1,i) = new_delT*(i-1);
        end
    end

    for i=1:length(s)
        s(i).delT = new_delT;
        s(i).timer = new_timer;
        s(i).vel=(s(i).pos(:,2:end)-s(i).pos(:,1:end-1))/s(i).delT;
        s(i).a=(s(i).vel(:,2:end)-s(i).vel(:,1:end-1))/s(i).delT;
    end
    traj_data=s;
end
[traj_data(1).minXY traj_data(1).minXYZ] = minDistance(traj_data);
[traj_data(1).maxV traj_data(1).maxA] = maxVandA(traj_data);
[traj_data(1).minThrust traj_data(1).maxThrust] = thrustRange(traj_data);