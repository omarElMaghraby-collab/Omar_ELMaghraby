USE Call_center_4;
GO

--Which products generate the most complaints and their CSAT distribution?
CREATE VIEW vw_Product_Complaints AS
SELECT 
    ProductID,
    Product_Name,
    COUNT(TicketID) AS Total_Complaints,
    AVG(CSAT_Score) AS Avg_CSAT
FROM Call_center_data
GROUP BY ProductID, Product_Name;

--Which agents and teams have highest CSAT and fastest resolution?
CREATE VIEW vw_Agent_Performance AS
SELECT TOP 100 PERCENT
AgentID,Agent_Name,Team,
AVG(CSAT_Score) AS Avg_CSAT,
AVG(ResolutionTime_Min) AS Avg_Resolution,
COUNT(TicketID) AS Total_Tickets
FROM Call_center_data
GROUP BY AgentID, Agent_Name, Team
ORDER BY Avg_CSAT DESC, Avg_Resolution ASC;
-----------------------------------------------
SELECT * FROM Call_center_data

--Which regions have lowest CSAT and highest complaints?
CREATE VIEW vw_Region_Complaints AS
SELECT Customer_s_Region,
COUNT(TicketID) AS Total_compliants, 
AVG(CSAT_Score) AS Avg_CSAT
FROM Call_center_data
GROUP BY Customer_s_Region;


--Effect of Channel on resolution and CSAT?
CREATE VIEW vw_Channel_Performance AS
SELECT Channel,
AVG(ResolutionTime_Min) AS Avg_resolution,
AVG(CSAT_Score) AS Avg_CSAT,
COUNT(TicketId) AS Total_ticket
FROM Call_center_data
GROUP BY Channel;

--Percentage of tickets escalated and top causes?
CREATE VIEW vw_Escalated_By_Topic AS
SELECT 
    Topic,
    COUNT(TicketID) AS Escalated_Count,
    CAST(COUNT(TicketID) * 100.0 /
        (SELECT COUNT(TicketID) 
         FROM Call_center_data
         WHERE Priority = 'High' OR Status = 'Escalated') 
    AS DECIMAL(10,2)) AS Percentage
FROM Call_center_data
WHERE Priority = 'High' OR Status = 'Escalated'
GROUP BY Topic;

--High churn risk customers?
CREATE VIEW vw_Customers_low_CSAT AS 
SELECT CustomerID,Customer_Name,
COUNT(TicketID) AS Total_complaints,
AVG(CSAT_Score) AS Avg_CSAT
FROM Call_center_data
GROUP BY CustomerID,Customer_Name
HAVING COUNT(TicketID) > 3 AND AVG(CSAT_Score) < 3;

--Correlation between priority and CSAT/resolution?
CREATE VIEW vw_Priority_Performance AS 
SELECT Priority,
AVG(CSAT_Score) AS Avg_CSAT,
AVG(ResolutionTime_Min) AS Avg_resolution,
COUNT(TicketID) AS Total_Tickets
FROM Call_center_data
GROUP BY Priority;

--Quality Agents impact on repeat issues CSAT?
CREATE VIEW vw_QualityAgent_Performance AS
SELECT 
    QualityAgentID,
    QualityAgent_Name,
    AVG(Quality_Score) AS Avg_Quality,
    AVG(CSAT_Score) AS Avg_CSAT,
    COUNT(TicketID) AS Total_Tickets
FROM Call_center_data
GROUP BY QualityAgentID, QualityAgent_Name;

--Top 10 agents to promote, bottom 10 for coaching? 

--Top 10 
CREATE VIEW vw_Top10_Agents AS 
SELECT TOP 10 
AgentID , Agent_Name,
AVG(CSAT_Score) AS Avg_csat,
AVG(ResolutionTime_Min) AS Avg_resolution
FROM Call_center_data
GROUP BY AgentID, Agent_Name
ORDER BY Avg_csat DESC, Avg_resolution ASC;

--Bottom 10 
CREATE VIEW vw_bottom10_agents AS 
SELECT TOP 10 
AgentID , Agent_Name,
AVG(CSAT_Score) AS Avg_csat,
AVG(ResolutionTime_Min) AS Avg_resolution
FROM Call_center_data
GROUP BY AgentID, Agent_Name
ORDER BY Avg_csat ASC, Avg_resolution DESC;

--Recommendations for high complaint but high revenue products?
CREATE VIEW vw_HighComplaints_HighCSAT_Products AS
SELECT 
    ProductID,
    Product_Name,
    COUNT(TicketID) AS Total_Complaints,
    AVG(CSAT_Score) AS Avg_CSAT
FROM Call_center_data
GROUP BY ProductID, Product_Name
HAVING COUNT(TicketID) > 50 AND AVG(CSAT_Score) >= 4;
