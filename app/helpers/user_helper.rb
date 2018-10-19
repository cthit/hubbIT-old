module UserHelper
  def link_to_add_fields(name, f, klass)
    new_object = klass.new
    id = new_object.object_id
    fields = f.fields_for :devices, new_object, child_index: id do |builder|
      render "device_fields", f: builder
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def device_name name
    unless name.blank?
      return name
    end
    "Unknown device"
  end
end
