class User

	def self.attributes
		[:id, :name, :email, :phone]
	end
	attr_accessor *self.attributes

	def self.load(id)
		if data = NSUserDefaults.standardUserDefaults["USER-#{id}"]
			NSKeyedUnarchiver.unarchiveObjectWithData(data)
		end
	end

	def initialize(attributes = {})
		self.class.attributes.each {|attribute|
			self.send("#{attribute}=", attributes[attribute])
		}
	end

	def save
		NSUserDefaults.standardUserDefaults["USER-#{id}"] = NSKeyedArchiver.archivedDataWithRootObject(self)
	end

	def initWithCoder(decoder)
		self.init
		self.class.attributes.each do |attribute_name|
			self.send("#{attribute_name}=", decoder.decodeObjectForKey(attribute_name.to_s))
		end
		self
	end

	def encodeWithCoder(encoder)
		self.class.attributes.each do |attribute_name|
			encoder.encodeObject(self.send(attribute_name), forKey: attribute_name.to_s)
		end
	end
end
