class SimpleIuguGenerator < Rails::Generators::NamedBase
  desc "This generator creates an initializer file at config/initializers"
  source_root File.expand_path("../templates", __FILE__)

  MissingModel = Class.new(Thor::Error)

  def initializer_file
    template 'simple_iugu.rb', 'config/initializers/simple_iugu.rb'
  end

  def locale_file
    copy_file '../../../../config/locale/simple_iugu.pt-BR.yml', 'config/locales/simple_iugu.pt-BR.yml'
  end

  def generate_migrations
		unless model_exists?
			raise MissingModel,
				"\n\tModel \"#{file_name.titlecase}\" doesn't exists. Please, create your Model and try again."
		end

		inject_into_file model_path, "\n\thas_one :customer, as: :customerable, class_name: 'Iugu::Customer'", after: '< ActiveRecord::Base'

    inject_into_file model_path, "\n\thas_one :customer, as: :customerable, class_name: 'Iugu::Customer'", after: '< ApplicationRecord'

    case self.behavior
    when :invoke
      generate "active_record:simple_iugu", file_name
    when :revoke
      Rails::Generators.invoke "active_record:simple_iugu", [file_name], behavior: :revoke
    end
  end

  private

  	def model_exists?
  		File.exist?(File.join(destination_root, model_path))
  	end

	  def model_path
		  @model_path ||= File.join("app", "models", "#{file_path}.rb")
		end
end
