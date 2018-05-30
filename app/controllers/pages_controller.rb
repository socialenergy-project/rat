class PagesController < ApplicationController
  def home
    @cards = [{message: "#{Message.where(recipient: current_user).count} Messages", color: "bg-primary", link: messages_path, image: "fa-comments"},
              {message: "#{Consumer.count} Consumers", color: "bg-warning", link: consumers_path, image: "fa-line-chart"},
              {message: "#{Community.count} Communities", color: "bg-success", link: communities_path, image: "fa-handshake-o"},
              {message: "#{Clustering.count} Clusterings", color: "bg-danger", link: clusterings_path, image: "fa-sitemap"},
              {message: "#{ClScenario.count} Clustering Algorithm Scenarios", color: "bg-info", link: cl_scenarios_path, image: "fa-sitemap"},
              {message: "#{Recommendation.count} Recommendations", color: "bg-primary", link: recommendations_path, image: "fa-money"},
              {message: "#{Scenario.count} Energy Program Scenarios", color: "bg-warning", link: scenarios_path, image: "fa-plug"}]

    now = DateTime.now
    today_in_2015 = now.change(year: 2015)
    @charts = [{
                   dom_id: :real_time_hour_chart,
                   title: 'Real time data for past hour',
                   community: Community.find(1).id,
                   params: {
                       'start_date': now - 60.minutes,
                       'end_date': now + 30.minutes,
                       'interval_id': Interval.find_by(duration: 60).id
                   }
               }, {
                   dom_id: :real_time_day_chart,
                   title: 'Real time data for past day',
                   community: Community.find(1).id,
                   params: {
                       'start_date': now - 24.hours,
                       'end_date': now + 1.hour,
                       'interval_id': Interval.find_by(duration: 900).id
                   }
               }, {
                   dom_id: :real_time_week_chart,
                   title: 'Real time data for past week',
                   community: Community.find(1).id,
                   params: {
                       'start_date': now - 1.week,
                       'end_date': now + 1.hour,
                       'interval_id': Interval.find_by(duration: 3600).id
                   }
               }, {
                   dom_id: :historical_day_chart,
                   title: 'Historical residential data for 1 day',
                   community: Community.find(105).id,
                   params: {
                       'start_date': today_in_2015,
                       'end_date': today_in_2015 + 1.day,
                       'interval_id': Interval.find_by(duration: 900).id
                   }
               }, {
                   dom_id: :historical_industrial_chart,
                   title: 'Historical industrial data for 1 week',
                   community: Community.find(100).id,
                   params: {
                       'start_date': today_in_2015  ,
                       'end_date': today_in_2015 + 1.week,
                       'interval_id': Interval.find_by(duration: 3600).id
                   }
               }, {
                   dom_id: :historical_professional_chart,
                   title: 'Historical professional data for 1 month',
                   community: Community.find(103).id,
                   params: {
                       'start_date': today_in_2015  ,
                       'end_date': today_in_2015 + 1.month,
                       'interval_id': Interval.find_by(duration: 86400).id
                   }
               }]

  end
end
