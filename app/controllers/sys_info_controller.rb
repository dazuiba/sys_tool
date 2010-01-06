class SysInfoController < ActionController::Base
	def index
		@svn_info = svn_info		
	end
	
	def reboot
		if File.file?("#{RAILS_ROOT}/tmp/restart.txt")
			`touch #{RAILS_ROOT}/tmp/restart.txt`
		elsif File.file?("#{RAILS_ROOT}/log/mongrel.pid")
			`mongrel_rails restart -c #{RAILS_ROOT}`
		end		
		redirect_to :action => "index"
	end

	def svn_up
		msg = `svn up #{RAILS_ROOT}`
		flash[:notice] = msg
		redirect_to :action => "index"
	end
	
	private
	
	def svn_info
		current_info = `svn info #{RAILS_ROOT}`
		return nil if current_info.blank?
		current_info = Hash[current_info.split("\n").map{|e|e.split(":",2)}]
		remote_info  = Hash[`svn info #{current_info["URL"]}`.split("\n").map{|e|e.split(":",2)}]
		{:current_info => current_info.slice("Last Changed Date","Last Changed Author","Last Changed Rev"), :remote_info => remote_info.slice("Last Changed Date","Last Changed Author","Last Changed Rev")}
	end
end
