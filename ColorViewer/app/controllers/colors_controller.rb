class ColorsController < UIViewController
	def initWithNibName(nibName, bundle: bundleId)
		super
		self.tabBarItem = tabBarItem
		self
	end

	def viewDidLoad
		super

		self.view.backgroundColor = UIColor.whiteColor
		self.view.addSubview colors_label
		self.title = "Colors"

		color_names.each_with_index do |color_name, index|
			self.view.addSubview color_button(color_name, index)
		end
	end

	def color_names
		["red", "green", "blue"]
	end

	def red_tapped
		openDetailForColor UIColor.redColor
	end

	def green_tapped
		openDetailForColor UIColor.greenColor
	end

	def blue_tapped
		openDetailForColor UIColor.blueColor
	end

	private

	def tabBarItem
		@tabBarItem ||= UITabBarItem.alloc.initWithTitle("Colors", image: nil, tag: 1)
	end

	def openDetailForColor(color)
		self.navigationController.pushViewController(ColorDetailController.alloc.initWithColor(color), animated: true)
	end

	def colors_label
		@colors_label ||= make_colors_label
	end

	def make_colors_label
		UILabel.alloc.initWithFrame(CGRectZero).tap do |label|
			label.text = "Colors"
			label.sizeToFit
			label.center = [
				self.view.frame.size.width / 2,
				self.view.frame.size.height / 2
			]
			label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
		end
	end

	def color_button(color_name, index)
		color = UIColor.send("#{color_name.downcase}Color")
		button_width = 80

		button = UIButton.buttonWithType(UIButtonTypeSystem)
		button.setTitle(color_name, forState:UIControlStateNormal)
		button.setTitleColor(color, forState:UIControlStateNormal)
		button.sizeToFit
		button.frame = [
			[30 + index*(button_width + 10), colors_label.frame.origin.y + button.frame.size.height + 30],
			[80, button.frame.size.height]
		]
		button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
		button.addTarget(self, action: "#{color_name}_tapped", forControlEvents:UIControlEventTouchUpInside)
	end
end
