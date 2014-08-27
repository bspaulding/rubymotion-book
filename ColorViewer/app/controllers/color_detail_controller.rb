class ColorDetailController < UIViewController
	def initWithColor(color)
		self.initWithNibName(nil, bundle: nil)
		@color = color
		self.title = "Detail"
		self
	end

	def viewDidLoad
		super
		self.view.backgroundColor = @color
		self.navigationItem.rightBarButtonItem = rightBarButtonItem
	end

	def change_color
		self.presentViewController(change_color_controller, animated: true, completion: lambda {})
	end

	private

	def change_color_controller
		@change_color_controller ||= ChangeColorController.alloc.initWithNibName(nil, bundle: nil).tap do |controller|
			controller.color_detail_controller = self
		end
	end

	def rightBarButtonItem
		@rightBarButtonItem ||= UIBarButtonItem.alloc.initWithTitle("Change", style: UIBarButtonItemStyleBordered,
																																					target: self,
																																					action: 'change_color')
	end
end
