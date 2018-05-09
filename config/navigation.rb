# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  #navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected' 
  #navigation.selected_class = 'selected'
  navigation.selected_class = 'active'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  #navigation.active_leaf_class = 'simple-navigation-active-leaf'

  # Specify if item keys are added to navigation items as id. Defaults to true
  #navigation.autogenerate_item_ids = true

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  #navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that
  # will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  #navigation.name_generator = Proc.new {|name, item| "<span>#{name}</span>"}

  # Specify if the auto highlight feature is turned on (globally, for the whole navigation). Defaults to true
  #navigation.auto_highlight = true
  
  # Specifies whether auto highlight should ignore query params and/or anchors when 
  # comparing the navigation items with the current URL. Defaults to true 
  #navigation.ignore_query_params_on_auto_highlight = true
  #navigation.ignore_anchors_on_auto_highlight = true
  
  # If this option is set to true, all item names will be considered as safe (passed through html_safe). Defaults to false.
  #navigation.consider_item_names_as_safe = false

  options = {html: {class: 'nav-item'}, link_html: {class: 'nav-link'}}
  dropdown_options = options.deep_dup
  dropdown_options[:html][:'data-toggle'] = 'tooltip'
  dropdown_options[:html][:'data-placement'] = 'right'
  dropdown_options[:link_html][:class] += ' nav-link-collapse'
  dropdown_options[:link_html][:'data-toggle'] = 'collapse'
  dropdown_options[:link_html][:'data-parent'] = '#exampleAccordion'

  # Define the primary navigation
  navigation.items do |primary|
    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>if: -> { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>unless: -> { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.
    #

    primary.dom_class = "navbar-nav navbar-sidenav"
    primary.dom_id = "exampleAccordion"

    primary.item :home, 'Home', root_path, options.deep_dup.merge(icon: ['fa fa-home fa-fw'])  # We add deep_dup otherwise the menu items end up with identical ids
    # primary.item :connection_types, 'Connection Types', connection_types_path, options.deep_dup
    primary.item :consumers, 'Consumers', "#collapseConsumers", dropdown_options.deep_dup.merge(icon: ['fa fa-line-chart fa-fw'])  do |sub_nav|
      ConsumerCategory.order(id: :asc).each do |cc|
        sub_nav.dom_class = 'sidenav-second-level collapse'
        sub_nav.dom_id = 'collapseConsumers'
        sub_nav.item "menu_consumers_#{cc.id}", cc.name, "#collapseConsumers_cat_#{cc.id}", dropdown_options.deep_dup.deep_merge({link_html: { 'data-parent': :consumers}}) do |sub_sub_nav|
          sub_sub_nav.dom_class = 'sidenav-third-level collapse'
          sub_sub_nav.dom_id = "collapseConsumers_cat_#{cc.id}"
          sub_sub_nav.item "menu_consumers_#{cc.id}_list", "Consumer list", consumers_path(category: cc), options.deep_dup.merge(highlights_on: ->() { request.url.ends_with? consumers_path(category: cc) } )
          sub_sub_nav.item "menu_consumers_#{cc.id}_new", "New Consumer", new_consumer_path(category: cc), options.deep_dup.merge(highlights_on: ->() { request.url.ends_with? new_consumer_path(category: cc) } )

          # cc.consumers.order(name: :asc).each do |consumer|
          #   sub_sub_nav.item "menu_consumers_#{cc.id}_#{consumer.id}", consumer.name, consumer_path(consumer), options.deep_dup
          # end
        end
      end
    end
    primary.item :communities, 'Communities', "#collapseCommunities", dropdown_options.deep_dup.merge(icon: 'fa fa-fw fa-handshake-o') do |sub_nav|
      sub_nav.dom_class = 'sidenav-second-level collapse'
      sub_nav.dom_id = 'collapseCommunities'
      sub_nav.item "menu_communities_list", "Community list", communities_path, options.deep_dup
      sub_nav.item "menu_communities_new", "New Community", new_community_path, options.deep_dup

=begin
      Clustering.order(name: :asc).each do |cl|
        sub_nav.item "menu_cl_#{cl.id}", cl.name, "#collapseCl_#{cl.id}", dropdown_options.deep_dup.deep_merge({link_html: { 'data-parent': '#collapseCommunities'}}) do |sub_sub_nav|
          sub_sub_nav.dom_class = 'sidenav-third-level collapse'
          sub_sub_nav.dom_id = "collapseCl_#{cl.id}"
          cl.communities.order(name: :asc).each do |c|
            sub_sub_nav.item "menu_communities_#{c.id}", c.name, community_path(c), options.deep_dup
          end
        end
      end
=end

    end
    primary.item :clustrings, 'Community Creation', "#collapseClusterings", dropdown_options.deep_dup.merge(icon: 'fa fa-fw fa-sitemap') do |sub_nav|
      sub_nav.dom_class = 'sidenav-second-level collapse'
      sub_nav.dom_id = 'collapseClusterings'
      sub_nav.item "menu_clusterings_list", "Clustering list", clusterings_path, options.deep_dup
      sub_nav.item "menu_cl_scenarios", "Clustering algorithms", cl_scenarios_path, options.deep_dup
      sub_nav.item "menu_clusterings_new", "New Clustering", new_cl_scenario_path, options.deep_dup
=begin
      Clustering.order(name: :asc).each do |c|
        sub_nav.item "menu_clusterings_#{c.id}", c.name, clustering_path(c), options.deep_dup
      end
=end

    end


#                 clusterings_path, options.deep_dup
    primary.item :reporting, 'Reporting/Recommendation', recommendations_path, options.deep_dup.merge(icon: ['fa fa-money fa-fw'])
    primary.item :dynamic_pricing, 'Energy Programs', scenarios_path, options.deep_dup.merge(icon: ['fa fa-plug fa-fw'])

=begin
    # Add an item which has a sub navigation (same params, but with block)
    primary.item :key_2, 'name2', "#collapseComponents", dropdown_options.deep_dup do |sub_nav|
      # Add an item to the sub navigation (same params again)
      sub_nav.item :key_2_1, 'name21', '#', options.deep_dup
      sub_nav.item :key_2_2, 'name22', new_connection_type_path, options.deep_dup
      sub_nav.dom_class = 'sidenav-second-level collapse'
      sub_nav.dom_id = 'collapseComponents'
    end

    primary.item :key_3, 'name3', "#collapseComponents3", dropdown_options.deep_dup do |sub_nav|
      # Add an item to the sub navigation (same params again)
      sub_nav.item :key_3_1, 'name31', '#', options.deep_dup
      sub_nav.item :key_3_2, 'name32', edit_connection_type_path(1), options.deep_dup
      sub_nav.dom_class = 'sidenav-second-level collapse'
      sub_nav.dom_id = 'collapseComponents3'
    end
=end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    primary.item :key_3, 'Admin', '/admin', options.merge(if: -> { current_user&.has_role? :admin }, icon: ['fa fa-user-o fa-fw'])

    # you can also specify html attributes to attach to this particular level
    # works for all levels of the menu
    #primary.dom_attributes = {id: 'menu-id', class: 'menu-class'}

    # You can turn off auto highlighting for a specific level
    #primary.auto_highlight = false
  end
end