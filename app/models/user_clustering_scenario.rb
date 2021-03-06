class UserClusteringScenario < ApplicationRecord
    has_many :user_clustering_parameters, dependent: :destroy
    has_many :user_clustering_results, dependent: :destroy

    validates :kappa, numericality: { greater_than_or_equal_to: 2,
                                      only_integer: true  }

    validates_length_of :name, minimum: 3, maximum: 30, allow_blank: false

    include Recommendable

    def get_params
        self.user_clustering_parameters.each_with_object({}) {|v,h| h[v.user_id] ||= {}; h[v.user_id][v.paramtype] ||= v.value }
    end

    def cluster_for(user_id)
        self.user_clustering_results&.find_by(user_id: user_id)&.cluster
    end

    def get_clusters
        self.user_clustering_results
            .group(:cluster)
            .select('array_agg(user_id) as users', :cluster)
            .order(cluster: :asc)
            .map{|ucr| [ucr.cluster, ucr.users]}.to_h
    end

    def get_results_for_plot(param1, param2)
        get_clusters.map do |cl, users|
           {
               label: "Cluster #{cl}",
               data: self.user_clustering_parameters
                         .where(paramtype: [param1, param2], user_id: users)
                         .group(:user_id)
                         .select('user_id, array_agg(paramtype ORDER BY paramtype ASC) as types,'\
                                 'array_agg(value ORDER BY paramtype ASC) as values')
                         .map{|ucp| {x: ucp.values[ucp.types.index(param1)],  y: ucp.values[ucp.types.index(param2)], label: ucp.user.uid } },
           }
        end.sort_by{|v| v[:label]}
    end

end
