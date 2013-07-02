function traj_data = load_traj_data(varargin)
%this function either laod data from a file located in ./trajectories or
%updates and exsisting trajectoryand recalculates the traj_data including
%velocity and acceleration. 
%
%The end of this function also has some function calls to collect
%superelative data on the trajectory
global rotrad quadwidth

if nargin == 1 %load new trajectory
    traj_name = varargin{1};
    data = load(['trajectories/', traj_name]);
    s = data.s;
    
    error_flg = 0;
    for i=1:length(s)
        s(i).v=(s(i).pos(:,2:end)-s(i).pos(:,1:end-1))/s(i).delT;
        % check if velocities are equal
        s(i).vel = s(i).vel(:,1:end-1);
        if compareVelocities(s(i).vel, s(i).v) == 1
            error_flg = 1;
        end
        %s(i).vel = s(i).v; % uncomment this line to use calculate velocity
        s(i).a=(s(i).vel(:,2:end)-s(i).vel(:,1:end-1))/s(i).delT; % calculate the acceleration
        s(i).cyl_flag =0; %flag for cylinders
        % if not already there add extra angles and flip fields (all or
        if (isfield(s(i), {'roll_extra', 'pitch_extra', 'flip_cmd'}) == [0 0 0]) |...
                (isempty(s(i).roll_extra) && isempty(s(i).pitch_extra) && isempty(s(i).flip_cmd))
            s(i).roll_extra = zeros(1, length(s(i).yaw));
            s(i).pitch_extra = zeros(1, length(s(i).yaw));
            s(i).flip_cmd = zeros(1, length(s(i).yaw));
        end
    end
    if(error_flg == 1)
        fprintf('given and calculated velocities do not match!');
    end
    s = checkFlips(s);
    check_traj(s);
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
    s = checkFlips(s);
    check_traj(s);
    traj_data=s;
end
[traj_data(1).minXY traj_data(1).minXYZ] = minDistance(traj_data, rotrad, quadwidth);
[traj_data(1).maxV traj_data(1).maxA] = maxVandA(traj_data);
[traj_data(1).minThrust traj_data(1).maxThrust] = thrustRange(traj_data);
[traj_data(1).maxRoll traj_data(1).maxPitch] = getMaxAngles(traj_data);