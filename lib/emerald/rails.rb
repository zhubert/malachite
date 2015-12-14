module Emerald
  class Client
    def path_to_tmp_file
      Rails.root.join('tmp', "#{@name}.so").to_s
    end
  end
end
