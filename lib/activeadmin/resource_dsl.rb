#-*- encoding: utf-8; tab-width: 2 -*-
require 'activeadmin'

module ActiveAdmin
  class ResourceDSL
    def add_reorder_mode
      config.sort_order = "position_asc"

      index :as => :sortable_table do
        selectable_column
        config.sort_order = "posts.position ASC"

        column :title

        actions
      end

      resource_class = @resource
      collection_action :reorder, :method => :put do
        ActiveadminDraggable::DraggableListItem.move(resource_class, params[:id], params[:left_id])
        head(:ok)
      end

      controller_name = @config.controller.name
      action_item :only => :index do
        path = Rails.application.routes.url_helpers.url_for(
               :controller => controller_name.underscore.gsub(/_controller$/,''),
               :action => :reorder,
               :only_path => true
             )
        link_to 'Reorder mode', path , :class => "reorder", "data-on_text" => "Reorder mode", "data-off_text" => "Reorder mode off"
      end
    end
  end
end
