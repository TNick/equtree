# require 'json'

module DfilesHelper

  
  # class SpecialUser
    
    # def setV(user_id, usr_perm)
      # @user_id = user_id
      # @usr_perm = usr_perm
    # end
    # def mayEdit()
      # return ( @usr_perm == PP_MAYEDIT )
    # end
    # def mayView()
      # return ( ( @usr_perm == PP_MAYEDIT ) or ( @usr_perm == PP_MAYVIEW ) )
    # end
    # def isValid()
      # return ( ( @user_id > 0 ) and ( ( @usr_perm == PP_MAYEDIT ) or ( @usr_perm == PP_MAYVIEW )  or ( @usr_perm == PP_PRIVATE ) ) )
    # end
    # def toJSON ()
      # result = {
          # id: @user_id,
          # perm: @usr_perm
        # }
      # return result
    # end
    
    
  # end
  
  # class SpecialUsers < Array
    
    # #def initialize()
    # #  @users_list = []
    # #end
    
    # def addSpecialUser( user_id, user_permission)
      # new_u = SpecialUser.new
      # new_u.setV(user_id,user_permission)
      # push( new_u )
    # end
    
    # def load(text)
      # return unless text
      # fromJSON(text)
    # end

    # def dump(text)
      # return toJSON()
      # #[text].pack 'm'
    # end
    
    # def toJSON ()
      # entries = []
      # each do |itr|
        # entries.push( itr.toJSON() )
      # end
      # result = {
          # entries: entries
        # }
      # return result
    # end
    
    # def fromJSON(text)
      # src_hash = JSON.parse(text)
      # src_hash.entries.each do |entry|
        # addSpecialUser(entry.id, entry.perm)
      # end
    # end
    
  # end
  
end
