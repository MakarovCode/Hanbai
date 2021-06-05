ActiveAdmin.register_page "Dashboard" do

    menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

        # content title: proc{ I18n.t("active_admin.dashboard") } do
        #     div class: "blank_slate_container", id: "dashboard_default_message" do
        #             javascript_include_tag "https://www.google.com/jsapi", "chartkick"
        #     end
        #
        #     columns do
        #       column do
        #           panel "Registros Diarios" do
        #               area_chart [{name: "Nuevos usuarios", data: User.group_by_day(:created_at).count}, {name: "Usuarios en DEMO", data: User.demo.group_by_day(:created_at).count}, {name: "Usuarios GOLD", data: User.gold.group_by_day(:created_at).count}, {name: "Usuarios SILVER", data: User.silver.group_by_day(:created_at).count}]
        #           end
        #       end
        #     end
        #
        #     columns do
        #         column do
        #             panel "Visitas Diarias" do
        #                 area_chart Visit.group_by_day(:started_at).count
        #             end
        #         end
        #
        #         column do
        #             panel "Uso de Funcionaldiad" do
        #                 bar_chart Visit.group(:landing_page).count, colors: ["#FE9A2E"]
        #             end
        #         end
        #     end
        #
        #     columns do
        #         column do
        #             panel "Visitas por país" do
        #                 geo_chart Visit.group(:country).count
        #             end
        #         end
        #     end
        #
        #     columns do
        #         column do
        #             panel "Visitas por región" do
        #                 pie_chart Visit.group(:region).count
        #             end
        #         end
        #
        #         column do
        #             panel "Visitas por región" do
        #                 pie_chart Visit.group(:city).count
        #             end
        #         end
        #     end
        # end
    end
