john      : dp
mary      : dp
bill      : dp

unicorn   : n
teacher   : n

left      : (dp ⇒ s)
smiles    : (dp ⇒ s)
cheats    : (dp ⇒ s)

saw       : ((dp ⇒ s) ⇐ dp)
loves     : ((dp ⇒ s) ⇐ dp)
serves    : ((dp ⇒ s) ⇐ dp)

the       : np ⇐ n
waiter    : n
nice      : (n ⇐ n)
old       : (n ⇐ n)
everyone  : s ⇦ (dp ⇨ s)
someone   : s ⇦ (dp ⇨ s)
same1     : n ⇦ ((n ⇐ n) ⇨ n)
same2     : ((dp ⇨ s) ⇦ (ds ⇨ (dp ⇨ s))) ⇦ ((n ⇐ n) ⇨ dp)