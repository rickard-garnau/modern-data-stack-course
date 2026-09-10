# 1. How much does it cost?

#### a) 
You have a simple workload that runs daily in Snowflake. The workload uses 0.5 credits per day. Calculate the total credit usage and cost for a 30-day month.

Enterprise 3$/credit
0.5 * 3 * 30 = 45$
_________________________________________________________________________________________________

#### b) 
Your workload varies throughout the month. For the first 10 days, you use 2 credits per day. 
For the next 10 days, you use 1.5 credits per day, and for the last 10 days, you use 1 credit per day. 
Calculate the total credit usage and cost for a 30-day month.

2 * 3 * 10 = 60 | 1.5 * 3 * 10 = 45 | 1 * 3 * 10 = 30 | 135$
_________________________________________________________________________________________________
#### c) 
You have three different warehouses running workloads simultaneously. Warehouse A is of size XS, Warehouse B is of size S, and Warehouse C is of size M. 
Warehouse A is used for 10h/day, B is used for 2h/day and C is used for 1h/day. Calculate the total monthly cost assuming each warehouse runs for the full 30-day month.

1 *  3 * 10 * 30 = 900 | 2 * 2 * 3 * 30 = 360 | 4 * 3 * 30 = 360
900 (A) + 360 (B) + 360 (C) = 1620$ 
_________________________________________________________________________________________________


#### d) 
Your Snowflake warehouse uses auto-scaling. For the first 10 days, it operates on 2 clusters for 10 hours per day. For the next 10 days, it scales up to 3 clusters for 10 hours per day. 
For the last 10 days, it scales up to 4 clusters for 10 hours per day. Calculate the total monthly budget. Assume the warehouse consumes 1 credit per hour per cluster.

Enterprise = 3$ / Credit
Cluster = 1$ / h
10 days * 10 h * 2 cluster * 3 (Enterprise) = 600
10 days * 10 h * 3 * 3 = 900
10 days * 10 h * 4 * 3 = 1200
total = 2700$