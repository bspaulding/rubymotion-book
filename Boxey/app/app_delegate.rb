class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
		@window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
		@window.backgroundColor = UIColor.whiteColor
		@window.makeKeyAndVisible

		@window.addSubview (@blueView = make_box)
		@window.addSubview add_button
		@window.addSubview remove_button
		add_labels_to_boxes
		@window.addSubview color_picker

    true
  end

	def box_color
		@boxColor ||= UIColor.blueColor
	end

	def box_color=(new_color)
		@boxColor = new_color if new_color.is_a? UIColor
	end

	def color_tapped
		color_prefix = color_picker.text
		color_method_name = "#{color_prefix.downcase}Color"
		if UIColor.respond_to?(color_method_name)
			self.box_color = UIColor.send(color_method_name)
			boxes.each {|box| box.backgroundColor = box_color }
		else
			UIAlertView.alloc.initWithTitle("Invalid Color", message: "#{color_prefix} is not a valid color",
																											 delegate: nil,
																											 cancelButtonTitle: "OK",
																											 otherButtonTitles: nil).show
		end
	end

	def textFieldShouldReturn(textfield)
		color_tapped
		textfield.resignFirstResponder
		false
	end

	def color_picker
		@colorPicker ||= make_color_picker
	end

	def make_color_picker
		textfield = UITextField.alloc.initWithFrame(CGRectZero)
		textfield.borderStyle = UITextBorderStyleRoundedRect
		textfield.text = "Blue"
		textfield.enablesReturnKeyAutomatically = true
		textfield.returnKeyType = UIReturnKeyDone
		textfield.autocapitalizationType = UITextAutocapitalizationTypeNone
		textfield.sizeToFit
		textfield.frame = CGRect.new(
			[@blueView.frame.origin.x + @blueView.frame.size.width + 10, @blueView.frame.origin.y + textfield.frame.size.height],
			textfield.frame.size
		)
		textfield.delegate = self
		textfield
	end

	def boxes
		@window.subviews.reject do |view|
			view.is_a?(UIButton) || view.is_a?(UILabel)
		end
	end

	def add_labels_to_boxes
		boxes.each {|box| add_label_to_box(box) }
	end

	def add_button
		@addButton ||= make_add_button
	end

	def remove_button
		@removeButton ||= make_remove_button
	end

	def make_remove_button
		button = UIButton.buttonWithType(UIButtonTypeSystem)
		button.setTitle("Remove", forState:UIControlStateNormal)
		button.sizeToFit
		button.frame = CGRect.new(
			[add_button.frame.origin.x + add_button.frame.size.width + 10, add_button.frame.origin.y],
			button.frame.size
		)
		button.addTarget(self, action: "remove_tapped", forControlEvents:UIControlEventTouchUpInside)
		button
	end

	def make_add_button
		@addButton = UIButton.buttonWithType(UIButtonTypeSystem)
		@addButton.setTitle("Add", forState:UIControlStateNormal)
		@addButton.sizeToFit
		@addButton.frame = CGRect.new(
			[10, @window.frame.size.height - 10 - @addButton.frame.size.height],
			@addButton.frame.size
		)
		@addButton.addTarget(self, action: "add_tapped", forControlEvents:UIControlEventTouchUpInside)
		@addButton
	end
	private :make_add_button

	def make_box(frame = CGRect.new([10, 40], [100, 100]))
		box = UIView.alloc.initWithFrame(frame)
		box.backgroundColor = box_color
		box
	end
	private :make_box


	def add_tapped
		last_view = @window.subviews[0]
		new_view = make_box(CGRect.new(
			[last_view.frame.origin.x,
				last_view.frame.origin.y + last_view.frame.size.height + 10],
			last_view.frame.size
		))
		@window.insertSubview(new_view, atIndex: 0)
		add_labels_to_boxes
	end

	def remove_tapped
		other_views = boxes
		last_view = other_views.last
		return unless last_view && other_views.count > 1

		animations = lambda {
			last_view.alpha = 0
			last_view.backgroundColor = UIColor.redColor
			other_views.reject {|view| view == last_view }.each {|view|
				new_origin = [
					view.frame.origin.x,
					view.frame.origin.y - (last_view.frame.size.height + 10)
				]
				view.frame = CGRect.new(new_origin, view.frame.size)
			}
		}

		complete = lambda {|finished|
			last_view.removeFromSuperview
			add_labels_to_boxes
		}

		UIView.animateWithDuration 0.5, animations: animations, completion: complete
	end

	def add_label_to_box(box)
		box.subviews.each(&:removeFromSuperview)

		label = UILabel.alloc.initWithFrame(CGRectZero)
		label.text = @window.subviews.index(box).to_s
		label.textColor = UIColor.whiteColor
		label.backgroundColor = UIColor.clearColor
		label.sizeToFit
		label.center = [box.frame.size.width / 2, box.frame.size.height / 2]
		box.addSubview label
	end
end
