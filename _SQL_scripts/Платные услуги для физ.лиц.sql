-- Платных услуг для физических лиц 

-- 1 выводит категории относящихся к физ.лицам + сам 50
select * from r_recipient_category
where parent = '50' or recipientcategory_id = '50'; 

--  2 выводит id услуг оказываемых физ.лицам
select * from service2r_recipient_category
where recipientcategory_id = '50' or recipientcategory_id = '54' or recipientcategory_id = '55' or recipientcategory_id = '59' ;

-- 1 и 2 запрос автоматом
select * from service2r_recipient_category
where recipientcategory_id in (select id from r_recipient_category where parent = '50') or recipientcategory_id = '50' ;

-- 3 выводит id платных услуг
select id from service
where free  = 'false';

-- 3.1 выводит id, название и статус бесплатно платных услуг
select id, title, free from service 
where free  = 'false'


-- Готовый -- не правильный
select id, title, free from service 
where id in (select service_id from service2r_recipient_category
where recipientcategory_id in (select id from r_recipient_category where parent = '50') or recipientcategory_id = '50') INTERSECT select id, title,free from service
where free = 'false' and id > 200000000000;

-- От Стаса -- не правильный
select * from r_state_structure rs, ps_passport p, status s, r_passport_class cl, service sr, passport_services ps
where not s.status like 'DELE%' and cl.id=p.passport_class and s.id=p.id and p.r_state_structure=rs.id and p.id > 50000000000 and
sr.id=ps.service_id and ps.passport_id=p.id and sr.free=false  ORDER BY rs.title
  
  
-- ПРАВИЛЬНЫЙ
select p.id, p.short_title, s.title, s.free from service s, passport_services ps, ps_passport p, status st
where s.id in (select service_id from service2r_recipient_category where recipientcategory_id in (select id from r_recipient_category where parent = '50' or parent = '54') or recipientcategory_id = '50') 
and s.free = 'false' and s.id > 200000000000 and s.id=ps.service_id and ps.passport_id=p.id and st.id=p.id and not st.status like 'DELE%' ORDER BY p.short_title


-- в работе, убрать дубли
select * from r_state_structure rs, ps_passport p, status s, r_passport_class cl, service sr, passport_services ps, service2r_recipient_category srcr
where not s.status like 'DELE%' and cl.id=p.passport_class and s.id=p.id and srcr.service_id=sr.id and p.r_state_structure=rs.id and p.id > 50000000000 and
sr.id=ps.service_id and ps.passport_id=p.id and sr.free=false 
ORDER BY sr.id


select st.id, st.title, p.short_title, p.full_title, s.status, p.id from r_state_structure st, ps_passport p, status s
where st.id=p.r_state_structure and  p.r_state_structure in (select id from r_state_structure
where id > 200000000000) and p.id=s.id and s.id in (select id from status   
where status like 'PUBLISHED' ) and not p.full_title like '(%' ORDER BY p.id

SELECT * 
FROM (
  (select object_id
  from status_history
  where status like 'PUBLISHED' and not object_type like 'RState%' and object_id > 200000000000 group by object_id) T1

  left join

  (select id, status 
  from status) T2

  on T1.object_id=T2.id
) T3
WHERE T3.status not like 'DELETED_PUBLISHED'


SELECT * FROM ((select object_id from status_history 
where status like 'PUBLISHED' and not object_type like 'RState%' and object_id > 200000000000 group by object_id) T1
left join 
(select id, status from status) T2 on T1.object_id=T2.id) T3  
WHERE T3.status not like 'DELETED_PUBLISHED'









