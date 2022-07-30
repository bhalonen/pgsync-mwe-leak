CREATE OR REPLACE FUNCTION spammer() returns void as 
$$
DECLARE
    domain_id memleak.domain.id%TYPE;
     user_id memleak.myuser.id%TYPE;
     customer_id memleak.customer.id%TYPE;
     inventory_id memleak.inventory.id%TYPE;
     item_id memleak.item.id%TYPE;
begin
    
   for cnt in 1..1 loop
         
        insert into memleak.domain (name) values('big_domain_name') returning id into domain_id;
        for cnt2 in 1..1 loop
             
            insert into memleak.myuser (name, domain_id) values('big_domain', domain_id) returning id into user_id;
            for cnt3 in 1..1 loop
                insert into memleak.customer (name, creator_id) values('big_domain', user_id) returning id into customer_id;
                for cnt4 in 1..1 loop
                    insert into memleak.item (name, customer_id) values('big_domain', customer_id);
                end loop;
            end loop;
        end loop;
   end loop;
   for cnt5 in 1..1 loop 
        insert into memleak.inventory (name) values('good stuff') returning id into inventory_id;
        for cnt6 in 1..1 loop
            SELECT id 
            into item_id
            FROM memleak.item  
            ORDER BY random()  
            LIMIT 1;

            insert into memleak.inventory_item (inventory_id, item_id) values (inventory_id, item_id);
        end loop;
   end loop;
   for cnt7 in 1..1 loop 
        for cnt8 in 1..1 loop
            SELECT id 
            into item_id
            FROM memleak.item  
            ORDER BY random()  
            LIMIT 1;
            SELECT id 
            into domain_id
            FROM memleak.domain  
            ORDER BY random()  
            LIMIT 1;
            insert into memleak.inventory_item (inventory_id, domain_id) values (inventory_id, domain_id);
        end loop;
   end loop;
end; 
$$  LANGUAGE plpgsql;