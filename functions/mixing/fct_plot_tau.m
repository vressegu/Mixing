function [on_tau2_global, on_tau_local] = fct_plot_tau(model,...
    on_tau_local_folding,on_tau_local_stretching,rate_switch,cax_alpha,day)
% Compute the inverse of the local time scale of stretching
%

%% Options for plots

% Plotting the log of the folding, shearing and streatching
plot_log = false;

% Day of advection
if nargin < 6
    day = 0;
end

% Bounds of the colorbar
if isfield(model.grid,'mask_keep_cart')
    cax_log_min = -30;
    cax_log_max = -20;
    cax_alpha = 2e-10;
end
if strcmp(model.type_data, 'toy2')
    cax_alpha = 2.8e-12;
end

% Discriminate curved and straigtht streamlines
rate_switch = abs(rate_switch) >=1 ;

% Choose 1/tau = 1/tau_f or 1/tau = 1/tau_s depending on the above criterion
s=size(on_tau_local_folding);
on_tau_local = on_tau_local_folding(:);
on_tau_local(~rate_switch) = on_tau_local_stretching(~rate_switch);
on_tau_local = reshape(on_tau_local,s);

if isfield(model.grid,'mask_keep_cart')
    % Applying mask and compute the space average of 1/tau
    on_tau2_global = 1/sum(model.grid.mask_keep_cart(:)) * ...
        sum( model.grid.mask_keep_cart(:) .* on_tau_local(:).^2);
else
    % Compute the space average of 1/tau
    on_tau2_global = 1/prod(model.grid.MX) * sum(on_tau_local(:).^2);
end
% tau_global = 1/sqrt(on_tau2_global) /(3600*24)

%% Filtering
%
% figure;imagesc(model.grid.x_ref,model.grid.x_ref,...
%     on_tau_local');axis xy; axis equal;
%
% % Filter
% sigma_filter_w = 1e4;
% filter_w = design_filter_6(model,sigma_filter_w);
% on_tau_local = conv2(on_tau_local,filter_w,'same');
%
% % Plot
% figure;imagesc(model.grid.x_ref,model.grid.x_ref,...
%     on_tau_local');axis xy; axis equal;
%
%
% % figure(24)
% % imagesc(log(on_tau_local'.^2));axis xy;axis equal

%% Plot log

if ~(isfield(model.folder,'hide_plots'))
    model.folder.hide_plots = false;
end
if ~model.folder.hide_plots
    
    % Grid
    x = model.grid.x_ref;
    y = model.grid.y_ref;
    
    % Other parameters
    taille_police = 12;
    id_part=1;
    type_data = model.type_data;
    folder_simu = model.folder.folder_simu;
    folder_simu = [ folder_simu '/Eulerian_mixing_criterion'];
    map = 'default';
    loc_colorbar = 'southoutside';
    % map = model.folder.colormap;
    
    width=9;
    % width=12;
    height=4;
    
    % width = 13;
    % % width = 3.3;
    % %     height = 3.2;
    ax = [x(end)-x(1) y(end)-y(1)] ;
    aspect_ratio = ax(2)/ax(1);
    % height = 0.265*aspect_ratio * width;
    % % height = 0.26*aspect_ratio * width;
    X0=[0 10];
    
    
    if plot_log
        
        figure(22);
        close;
        figure22=figure(22);
        set(figure22,'Units','inches', ...
            'Position',[X0(1) X0(2) width height], ...
            'PaperPositionMode','auto');
        
        
        
        subplot(1,3,3)
        imagesc(x,y,log((on_tau_local.^2)'));
        set(gca,...
            'Units','normalized',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        ylabel('y(m)',...
            'FontUnits','points',...
            'interpreter','latex',...
            'FontSize',taille_police,...
            'FontName','Times')
        xlabel('x(m)',...
            'interpreter','latex',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        title('\hspace{0.5cm} $-2ln(\tau)$',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'interpreter','latex',...
            'FontSize',12,...
            'FontName','Times')
        axis xy; axis equal
        axis([x(1) x(end) y(1) y(end)])
        colormap(map)
        %colorbar
        colorbar('location',loc_colorbar)
        drawnow
        cax=caxis;
        if exist('cax_log_min','var')==1
            cax(1)=cax_log_min;
        end
        if exist('cax_log_max','var')==1
            cax(2)=cax_log_max;
        end
        caxis(cax);
        % cax(2)=max( [ max(on_tau_local_folding(:)) ...
        %     max(on_tau_local_stretching(:)) ...
        %     max(on_tau_local(:)) ]);
        % caxis(cax);
        
        % imagesc(x,y,log((on_tau_local.^2)'));
        subplot(1,3,1)
        imagesc(x,y,log((on_tau_local_folding.^2)'));
        set(gca,...
            'Units','normalized',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        ylabel('y(m)',...
            'FontUnits','points',...
            'interpreter','latex',...
            'FontSize',taille_police,...
            'FontName','Times')
        xlabel('x(m)',...
            'interpreter','latex',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        title('\hspace{0.5cm} $-2ln(\tau_f)$',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'interpreter','latex',...
            'FontSize',12,...
            'FontName','Times')
        axis xy; axis equal
        axis([x(1) x(end) y(1) y(end)])
        colormap(map)
        % colorbar
        colorbar('location',loc_colorbar)
        drawnow
        caxis(cax);
        
        subplot(1,3,2)
        imagesc(x,y,log((on_tau_local_stretching.^2)'));
        set(gca,...
            'Units','normalized',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        ylabel('y(m)',...
            'FontUnits','points',...
            'interpreter','latex',...
            'FontSize',taille_police,...
            'FontName','Times')
        xlabel('x(m)',...
            'interpreter','latex',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        title('\hspace{0.5cm} $-2ln(\tau_s)$',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'interpreter','latex',...
            'FontSize',12,...
            'FontName','Times')
        axis xy; axis equal
        axis([x(1) x(end) y(1) y(end)])
        colormap(map)
        %colorbar
        colorbar('location',loc_colorbar)
        drawnow
        caxis(cax);
        
        eval( ['print -depsc ' folder_simu '/log_on_tau_2_all'...
            num2str(day) '.eps']);
        % keyboard;
    end
    
    
    %% Plot
    
    figure(23);
    close;
    figure23=figure(23);
    set(figure23,'Units','inches', ...
        'Position',[X0(1) X0(2) width height], ...
        'PaperPositionMode','auto');
    
    
    subplot(1,3,3)
    imagesc(x,y,((on_tau_local.^2)'));
    set(gca,...
        'Units','normalized',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',taille_police,...
        'FontName','Times')
    ylabel('y(m)',...
        'FontUnits','points',...
        'interpreter','latex',...
        'FontSize',taille_police,...
        'FontName','Times')
    xlabel('x(m)',...
        'interpreter','latex',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',taille_police,...
        'FontName','Times')
    title('\hspace{0.5cm} $1/\tau^2$',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'interpreter','latex',...
        'FontSize',12,...
        'FontName','Times')
    axis xy; axis equal
    axis([x(1) x(end) y(1) y(end)])
    colormap(map)
    %colorbar
    colorbar('location',loc_colorbar)
    drawnow
    cax=caxis;
    if nargin == 5 || (exist('cax_alpha','var')==1)
        cax(2)=cax_alpha;
        caxis(cax);
    end
    
    % imagesc(x,y,log((on_tau_local.^2)'));
    subplot(1,3,1)
    imagesc(x,y,((on_tau_local_folding.^2)'));
    set(gca,...
        'Units','normalized',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',taille_police,...
        'FontName','Times')
    ylabel('y(m)',...
        'FontUnits','points',...
        'interpreter','latex',...
        'FontSize',taille_police,...
        'FontName','Times')
    xlabel('x(m)',...
        'interpreter','latex',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',taille_police,...
        'FontName','Times')
    title('\hspace{0.5cm} $1/\tau_f^2$',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'interpreter','latex',...
        'FontSize',12,...
        'FontName','Times')
    axis xy; axis equal
    axis([x(1) x(end) y(1) y(end)])
    colormap(map)
    %colorbar
    colorbar('location',loc_colorbar)
    drawnow
    caxis(cax);
    
    subplot(1,3,2)
    imagesc(x,y,((on_tau_local_stretching.^2)'));
    set(gca,...
        'Units','normalized',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',taille_police,...
        'FontName','Times')
    ylabel('y(m)',...
        'FontUnits','points',...
        'interpreter','latex',...
        'FontSize',taille_police,...
        'FontName','Times')
    xlabel('x(m)',...
        'interpreter','latex',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',taille_police,...
        'FontName','Times')
    title('\hspace{0.5cm} $1/\tau_s^2$',...
        'FontUnits','points',...
        'FontWeight','normal',...
        'interpreter','latex',...
        'FontSize',12,...
        'FontName','Times')
    axis xy; axis equal
    axis([x(1) x(end) y(1) y(end)])
    colormap(map)
    %colorbar
    colorbar('location',loc_colorbar)
    drawnow
    caxis(cax);
    
    eval( ['print -depsc ' folder_simu '/on_tau_2_all'...
        num2str(day) '.eps']);
    % keyboard;
    
    %% Plots longitude - latitude
    
    
    if isfield(model.grid,'lonlat')
        
        % Grid
        x = model.grid.x_ref;
        y = model.grid.y_ref;
        lon = model.grid.lonlat.lon;
        lat = model.grid.lonlat.lat;
        lonlat_ref = model.grid.lonlat.lonlat_ref;
        
        [LON,LAT]=ndgrid(lon,lat);
        on_tau_local = ...
            fct_cart2sph(x,y,on_tau_local,LON,LAT,lonlat_ref);
        on_tau_local_stretching = ...
            fct_cart2sph(x,y,on_tau_local_stretching,LON,LAT,lonlat_ref);
        on_tau_local_folding = ...
            fct_cart2sph(x,y,on_tau_local_folding,LON,LAT,lonlat_ref);
        
        x = lon;y=lat;
        
        % Other parameters
        taille_police = 12;
        %     id_part=1;
        %     type_data = model.type_data;
        folder_simu = model.folder.folder_simu;
        folder_simu = [ folder_simu '/Eulerian_mixing_criterion_lonlat'];
        map = 'default';
        loc_colorbar = 'southoutside';
        % map = model.folder.colormap;
        
        width=9;
        % width=12;
        height=4;
        
        % width = 13;
        % % width = 3.3;
        % %     height = 3.2;
        ax = [x(end)-x(1) y(end)-y(1)] ;
        aspect_ratio = ax(2)/ax(1);
        % height = 0.265*aspect_ratio * width;
        % % height = 0.26*aspect_ratio * width;
        X0=[0 10];
        
        if plot_log
            
            figure(22);
            close;
            figure22=figure(22);
            set(figure22,'Units','inches', ...
                'Position',[X0(1) X0(2) width height], ...
                'PaperPositionMode','auto');
            
            
            
            subplot(1,3,3)
            imagesc(x,y,log((on_tau_local.^2)'));
            set(gca,...
                'Units','normalized',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'FontSize',taille_police,...
                'FontName','Times')
            ylabel('Lat($^{\circ}$)',...
                'FontUnits','points',...
                'interpreter','latex',...
                'FontSize',taille_police,...
                'FontName','Times')
            xlabel('Lon($^{\circ}$)',...
                'interpreter','latex',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'FontSize',taille_police,...
                'FontName','Times')
            title('\hspace{0.5cm} $-2ln(\tau)$',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'interpreter','latex',...
                'FontSize',12,...
                'FontName','Times')
            axis xy; axis equal
            axis([x(1) x(end) y(1) y(end)])
            colormap(map)
            %colorbar
            colorbar('location',loc_colorbar)
            drawnow
            cax=caxis;
            if exist('cax_log_min','var')==1
                cax(1)=cax_log_min;
            end
            if exist('cax_log_max','var')==1
                cax(2)=cax_log_max;
            end
            caxis(cax);
            
            subplot(1,3,1)
            imagesc(x,y,log((on_tau_local_folding.^2)'));
            set(gca,...
                'Units','normalized',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'FontSize',taille_police,...
                'FontName','Times')
            ylabel('Lat($^{\circ}$)',...
                'FontUnits','points',...
                'interpreter','latex',...
                'FontSize',taille_police,...
                'FontName','Times')
            xlabel('Lon($^{\circ}$)',...
                'interpreter','latex',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'FontSize',taille_police,...
                'FontName','Times')
            title('\hspace{0.5cm} $-2ln(\tau_f)$',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'interpreter','latex',...
                'FontSize',12,...
                'FontName','Times')
            axis xy; axis equal
            axis([x(1) x(end) y(1) y(end)])
            colormap(map)
            % colorbar
            colorbar('location',loc_colorbar)
            drawnow
            caxis(cax);
            
            subplot(1,3,2)
            imagesc(x,y,log((on_tau_local_stretching.^2)'));
            set(gca,...
                'Units','normalized',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'FontSize',taille_police,...
                'FontName','Times')
            ylabel('Lat($^{\circ}$)',...
                'FontUnits','points',...
                'interpreter','latex',...
                'FontSize',taille_police,...
                'FontName','Times')
            xlabel('Lon($^{\circ}$)',...
                'interpreter','latex',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'FontSize',taille_police,...
                'FontName','Times')
            title('\hspace{0.5cm} $-2ln(\tau_s)$',...
                'FontUnits','points',...
                'FontWeight','normal',...
                'interpreter','latex',...
                'FontSize',12,...
                'FontName','Times')
            axis xy; axis equal
            axis([x(1) x(end) y(1) y(end)])
            colormap(map)
            %colorbar
            colorbar('location',loc_colorbar)
            drawnow
            caxis(cax);
            
            eval( ['print -depsc ' folder_simu '/log_on_tau_2_all'...
                num2str(day) '.eps']);
            % keyboard;
        end
        
        %% Plot
        
        figure(23);
        close;
        figure23=figure(23);
        set(figure23,'Units','inches', ...
            'Position',[X0(1) X0(2) width height], ...
            'PaperPositionMode','auto');
        
        
        subplot(1,3,3)
        imagesc(x,y,((on_tau_local.^2)'));
        set(gca,...
            'Units','normalized',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        ylabel('Lat($^{\circ}$)',...
            'FontUnits','points',...
            'interpreter','latex',...
            'FontSize',taille_police,...
            'FontName','Times')
        xlabel('Lon($^{\circ}$)',...
            'interpreter','latex',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        title('\hspace{0.5cm} $1/\tau^2$',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'interpreter','latex',...
            'FontSize',12,...
            'FontName','Times')
        axis xy; axis equal
        axis([x(1) x(end) y(1) y(end)])
        colormap(map)
        %colorbar
        colorbar('location',loc_colorbar)
        drawnow
        cax=caxis;
        if nargin == 5 || (exist('cax_alpha','var')==1)
            cax(2)=cax_alpha;
            caxis(cax);
        end
        
        subplot(1,3,1)
        imagesc(x,y,((on_tau_local_folding.^2)'));
        set(gca,...
            'Units','normalized',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        ylabel('Lat($^{\circ}$)',...
            'FontUnits','points',...
            'interpreter','latex',...
            'FontSize',taille_police,...
            'FontName','Times')
        xlabel('Lon($^{\circ}$)',...
            'interpreter','latex',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        title('\hspace{0.5cm} $1/\tau_f^2$',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'interpreter','latex',...
            'FontSize',12,...
            'FontName','Times')
        axis xy; axis equal
        axis([x(1) x(end) y(1) y(end)])
        colormap(map)
        %colorbar
        colorbar('location',loc_colorbar)
        drawnow
        caxis(cax);
        
        subplot(1,3,2)
        imagesc(x,y,((on_tau_local_stretching.^2)'));
        set(gca,...
            'Units','normalized',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        ylabel('Lat($^{\circ}$)',...
            'FontUnits','points',...
            'interpreter','latex',...
            'FontSize',taille_police,...
            'FontName','Times')
        xlabel('Lon($^{\circ}$)',...
            'interpreter','latex',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'FontSize',taille_police,...
            'FontName','Times')
        title('\hspace{0.5cm} $1/\tau_s^2$',...
            'FontUnits','points',...
            'FontWeight','normal',...
            'interpreter','latex',...
            'FontSize',12,...
            'FontName','Times')
        axis xy; axis equal
        axis([x(1) x(end) y(1) y(end)])
        colormap(map)
        %colorbar
        colorbar('location',loc_colorbar)
        drawnow
        caxis(cax);
        
        eval( ['print -depsc ' folder_simu '/on_tau_2_all'...
            num2str(day) '.eps']);
        
    end
end

end

function f_ortho = fct_ortho(f)
% Compute the orthogonal vector in each point of the space
%
f_ortho(:,:,1)= - f(:,:,2);
f_ortho(:,:,2)= + f(:,:,1);
end

function g = fct_normalize(g)
% Compute the orthogonal vector in each point of the space
%
ng = sqrt(sum(g.^2,3));
g = bsxfun( @times, 1./ng , g);
end