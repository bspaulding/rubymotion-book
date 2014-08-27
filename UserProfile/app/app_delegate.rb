class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
		@window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
		@window.rootViewController = navigation_controller
		@window.makeKeyAndVisible
    true
  end

	def applicationDidEnterBackground(application)
		test_user.save
	end

	private

	def navigation_controller
		@navigation_controller ||= UINavigationController.alloc.initWithRootViewController(user_controller)
	end

	def user_controller
		@user_controller ||= UserController.alloc.initWithUser(test_user)
	end

	def test_user
		@test_user ||= (User.load("123") || default_user)
	end

	def default_user
		User.new(id: "123", name: "Clay", email: "clay@mail.com", phone: "555-5555")
	end
end
