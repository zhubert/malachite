module Emerald
  class Client
    def path_to_tmp_file(name)
      Rails.root.join('tmp', "#{name}.so")
    end
  end
end
