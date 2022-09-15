//trigger to update child by parent
trigger trg1 on Account(after update)
{
  Set<Id> accId = new Set<Id>();
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        if(!trigger.new.isEmpty())
        {
            for(Account acc : trigger.new)
            {
                accId.add(acc.Id);
            }
        }
    }
    
    List<Contact> conList = [Select Id,Phone,AccountId from Contact where AccountId IN : accId];
    List<Contact> contList = new List<Contact>();
    
    for(Contact con : conList)
    {
        if(!checkRecursive.SetOfIDs.contains(trigger.newMap.get(con.AccountId).Id))
        {
            con.Phone = trigger.newMap.get(con.AccountId).Phone;
            contList.add(con);
            checkRecursive.SetOfIDs.add(trigger.newMap.get(con.AccountId).Id);
        }
    }
    if(!contList.isEmpty())
    {
        update contList;
    }
}
