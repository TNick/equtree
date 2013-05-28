module DfilesHelper
  PP_PRIVATE = 0
  PP_MAYVIEW = 1
  PP_MAYEDIT = 2
  
  
  class SpecialUser
    
    def setV(user_id, usr_perm)
      @user_id = user_id
      @usr_perm = usr_perm
    end
    def mayEdit()
      return ( @usr_perm == PP_MAYEDIT )
    end
    def mayView()
      return ( ( @usr_perm == PP_MAYEDIT ) or ( @usr_perm == PP_MAYVIEW ) )
    end
    def isValid()
      return ( ( @user_id > 0 ) and ( ( @usr_perm == PP_MAYEDIT ) or ( @usr_perm == PP_MAYVIEW )  or ( @usr_perm == PP_PRIVATE ) ) )
    end
  end
  
  class SpecialUsers
    
    def initialize()
      @users_list = []
    end
    
    def addSpecialUser( user_id, user_permission)
      new_u = SpecialUser.new
      new_u.setV(user_id,user_permission)
      @users_list.push( new_u )
    end
    
  end
  
end
