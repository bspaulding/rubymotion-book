class ChangeColorController < UIViewController
	attr_accessor :color_detail_controller

	def viewDidLoad
		super
		self.title = "Change Color"
		self.view.backgroundColor = UIColor.whiteColor
		self.view.addSubview text_field
		self.view.addSubview commit_button
	end

	private

	def text_field
		return @text_field if @text_field

		field = UITextField.alloc.initWithFrame(CGRectZero)
		field.borderStyle = UITextBorderStyleRoundedRect
		field.textAlignment = UITextAlignmentCenter
		field.placeholder = "Enter a color"
		field.frame = [CGPointZero, [150, 32]]
		field.center = [
			self.view.frame.size.width / 2,
			self.view.frame.size.height / 2
		]

		@text_field = field
	end

	def commit_button
		button = UIButton.buttonWithType(UIButtonTypeSystem)
		button.setTitle("Change", forState:UIControlStateNormal)
		button.frame = [
			[text_field.frame.origin.x, text_field.frame.origin.y + text_field.frame.size.height + 10],
			text_field.frame.size
		]
		button.addTarget(self, action:"change_color", forControlEvents:UIControlEventTouchUpInside)

		button
	end

	def change_color
		color_text = text_field.text.downcase || ""
		color_method = "#{color_text}Color"
		if UIColor.respond_to?(color_method)
			color = UIColor.send color_method
			self.color_detail_controller.view.backgroundColor = color
			self.dismissViewControllerAnimated(true, completion: nil)
		else
			text_field.text = "Error!"
		end
	end
end
