class ApplicationController < ActionController::Base
  before_action :set_locale

  def index
  end

  # TODO вынести в tasks_controller
  def show_task
    task = Task.find_by(token: params[:token])
    task.update_column(:views_count, task.views_count + 1)

    data = JSON.parse(task.expression)
    @result = COwl.creating_task(data)
  end

  def check_expression
    data = JSON.parse(params[:data])
    result = COwl.creating_task(data)

    respond_to do |format|
      format.html {
        render json: {
          trace_html: render_to_string(partial: 'application/common/trace_field',
                                       locals: {
                                         data: result
                                       },
                                       layout: false),
          errors_html: render_to_string(partial: 'application/index/errors',
                                        locals: {
                                          errors: result[:syntax_errors]
                                        },
                                        layout: false)
        }
      }
    end
  end

  # TODO вынести в tasks_controller
  def create_task
    task = Task.new(task_params)

    respond_to do |format|
      if task.save
        format.json { render json: { task_path: "/tasks/#{task.token}" }, status: :created }
      else
        head :bad_request
      end
    end
  end

  def verify_trace_act
    data = JSON.parse(params[:data])
    result = COwl.verify_trace_act(data)

    respond_to do |format|
      format.html { render partial: 'application/show_task/algorithm_trainer', locals: { data: result } }
    end
  end

  private
    def set_locale
      locale_from_header = extract_locale_from_accept_language_header
      I18n.locale =
        if params[:locale] && locale_exist?(params[:locale].to_sym)
          params[:locale].to_sym
        elsif locale_from_header.present? && locale_exist?(locale_from_header)
          locale_from_header
        else
          I18n.default_locale
        end
    end

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
    end

    def locale_exist?(locale)
      I18n.available_locales.include?(locale)
    end

    # TODO вынести в tasks_controller
    def task_params
      params.require(:task).permit(:expression)
    end
end
