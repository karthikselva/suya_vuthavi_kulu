module Transaction
  class GBInner
    def initialize(status)
      @status=status
    end
    
    def b
      st= yield
      @status = (st.class==Array ? st[0] : st)&&  @status 
    end
    
    def status
      @status
    end
  end
  
  class GuardedBlockException < Exception
  end
  
  
  class GuardedBlock
    def self.within_transaction (&block)
      ret_val= nil
      begin
        ActiveRecord::Base.transaction do
          ret_val= yield
          if !ret_val then
            raise GuardedBlockException.new
          end
        end
      rescue GuardedBlockException
      end   
      ret_val
    end
    
    def self.execute (status=true, &block)
      self.within_transaction do
        gb_inner= GBInner.new(status)
        yield gb_inner
        gb_inner.status
      end
    end
    
  end
  
end
