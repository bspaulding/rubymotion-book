class UserController < UIViewController
	include BubbleWrap::KVO

	attr_reader :user

	def initWithUser(user)
		initWithNibName(nil, bundle: nil)
		@user = user
		self.edgesForExtendedLayout = UIRectEdgeNone
		self
	end

	def viewDidLoad
		super

		self.view.backgroundColor = UIColor.whiteColor

		User.attributes.inject(nil) do |last_label, property_name|
			property_name_label = make_label("#{property_name.capitalize}:", below: last_label)
			self.view.addSubview property_name_label
			property_value_label = make_label(user.send(property_name), beside: property_name_label)
			observe(self.user, property_name) do |old, new|
				property_value_label.text = new
				property_value_label.sizeToFit
			end
			self.view.addSubview property_value_label

			property_name_label
		end

		self.title = self.user.name
		observe(self.user, "name") do |old, new|
			self.title = new
		end
	end

	def viewDidUnload
		unobserve_all
		super
	end

	private

	def make_label(text, options)
		label = UILabel.alloc.initWithFrame(CGRectZero)
		label.text = text
		label.sizeToFit
		label.frame = if options[:below]
			[
				[options[:below].frame.origin.x, options[:below].frame.origin.y + options[:below].frame.size.height],
				label.frame.size
			]
		elsif options[:beside]
			[
				[options[:beside].frame.origin.x + options[:beside].frame.size.width + 10, options[:beside].frame.origin.y],
				label.frame.size
			]
		else
			[[10, 10], label.frame.size]
		end

		label
	end
end
