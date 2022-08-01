Выполнил анализ до создания индексов:
alexndrlisitsin=> EXPLAIN ANALYZE select COUNT(*) from orders o INNER JOIN order_product op ON o.id = op.order_id INNER JOIN product p ON op.product_id = p.id WHERE p.id = 4;

                                                                            QUERY PLAN
------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Finalize Aggregate  (cost=407739.43..407739.44 rows=1 width=8) (actual time=6834.961..6858.172 rows=1 loops=1)
   ->  Gather  (cost=407739.21..407739.42 rows=2 width=8) (actual time=5065.331..6858.155 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=406739.21..406739.22 rows=1 width=8) (actual time=6199.338..6199.343 rows=1 loops=3)
               ->  Hash Join  (cost=232777.66..405000.70 rows=695403 width=0) (actual time=1085.139..6172.330 rows=555145 loops=3)
                     Hash Cond: (o.id = op.order_id)
                     ->  Parallel Seq Scan on orders o  (cost=0.00..105361.68 rows=4166668 width=8) (actual time=0.012..377.524 rows=3333334 loops=3)
                     ->  Hash  (cost=205395.57..205395.57 rows=1668967 width=8) (actual time=1083.736..1083.739 rows=1665436 loops=3)
                           Buckets: 131072  Batches: 32  Memory Usage: 3066kB
                           ->  Nested Loop  (cost=0.00..205395.57 rows=1668967 width=8) (actual time=0.043..834.725 rows=1665436 loops=3)
                                 ->  Seq Scan on product p  (cost=0.00..10.88 rows=1 width=8) (actual time=0.019..0.022 rows=1 loops=3)
                                       Filter: (id = 4)
                                       Rows Removed by Filter: 5
                                 ->  Seq Scan on order_product op  (cost=0.00..188695.03 rows=1668967 width=16) (actual time=0.022..703.325 rows=1665436 loops=3)
                                       Filter: (product_id = 4)
                                       Rows Removed by Filter: 8334566
 Planning Time: 0.339 ms
 Execution Time: 6858.287 ms
(19 rows)


После создал индексы:

   tablename   |                   indexname                   |                                                            indexdef
---------------+-----------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------
 order_product | idx_order_product_orderid                     | CREATE INDEX idx_order_product_orderid ON public.order_product USING btree (order_id)
 order_product | idx_order_product_orderid_quantity_product_id | CREATE INDEX idx_order_product_orderid_quantity_product_id ON public.order_product USING btree (order_id, quantity, product_id)
 orders        | idx_orders_id                                 | CREATE INDEX idx_orders_id ON public.orders USING btree (id)
 orders        | idx_orders_id_status_date_created             | CREATE INDEX idx_orders_id_status_date_created ON public.orders USING btree (id, status, date_created)
 orders        | idx_orders_id_statusd                         | CREATE INDEX idx_orders_id_statusd ON public.orders USING btree (id, status)
 product       | idx_product_id                                | CREATE INDEX idx_product_id ON public.product USING btree (id)


alexndrlisitsin=> EXPLAIN ANALYZE select COUNT(*) from orders o INNER JOIN order_product op ON o.id = op.order_id INNER JOIN product p ON op.product_id = p.id WHERE p.id = 4;
                                                                            QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Finalize Aggregate  (cost=309535.95..309535.96 rows=1 width=8) (actual time=1820.713..1840.673 rows=1 loops=1)
   ->  Gather  (cost=309535.73..309535.94 rows=2 width=8) (actual time=1820.555..1840.664 rows=3 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         ->  Partial Aggregate  (cost=308535.73..308535.74 rows=1 width=8) (actual time=1816.431..1816.434 rows=1 loops=3)
               ->  Merge Join  (cost=1.27..306797.23 rows=695403 width=0) (actual time=1.891..1787.168 rows=555145 loops=3)
                     Merge Cond: (o.id = op.order_id)
                     ->  Parallel Index Only Scan using idx_orders_id on orders o  (cost=0.43..119090.12 rows=4166668 width=8) (actual time=0.044..340.024 rows=3333332 loops=3)
                           Heap Fetches: 37
                     ->  Materialize  (cost=0.43..166164.70 rows=1668967 width=8) (actual time=0.078..1076.711 rows=1665398 loops=3)
                           ->  Nested Loop  (cost=0.43..161992.29 rows=1668967 width=8) (actual time=0.075..826.945 rows=1665398 loops=3)
                                 ->  Index Only Scan using idx_order_product_orderid_quantity_product_id on order_product op  (cost=0.43..141129.12 rows=1668967 width=16) (actual time=0.056..392.859 
rows=1665398 loops=3)
                                       Index Cond: (product_id = 4)
                                       Heap Fetches: 6
                                 ->  Materialize  (cost=0.00..1.08 rows=1 width=8) (actual time=0.000..0.000 rows=1 loops=4996194)
                                       ->  Seq Scan on product p  (cost=0.00..1.07 rows=1 width=8) (actual time=0.015..0.015 rows=1 loops=3)
                                             Filter: (id = 4)
                                             Rows Removed by Filter: 5
 Planning Time: 0.463 ms
 Execution Time: 1840.760 ms
(20 rows)
