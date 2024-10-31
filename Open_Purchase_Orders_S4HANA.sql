-- Here’s a SQL query that will help you identify purchase orders pending closure for over 90 days in an SAP S/4HANA system using the relevant tables (EKKO, EKPO, EKBE, EKET)
SELECT 
    EKKO.EBELN AS Purchase_Order_Number,
    EKKO.BEDAT AS PO_Creation_Date,
    EKKO.LIFNR AS Vendor,
    EKPO.EBELP AS Item_Number,
    EKPO.MATNR AS Material_Number,
    EKPO.MENGE AS Ordered_Quantity,
    EKPO.NETWR AS Net_Value,
    EKPO.LOEKZ AS Deletion_Indicator,
    EKPO.ELIKZ AS Delivery_Completed_Indicator,
    EKPO.EREKZ AS Final_Invoice_Indicator,
    MAX(EKBE.BUDAT) AS Last_PO_History_Date,
    EKET.EINDT AS Expected_Delivery_Date
FROM 
    EKKO 
    INNER JOIN EKPO ON EKKO.EBELN = EKPO.EBELN
    LEFT JOIN EKET ON EKPO.EBELN = EKET.EBELN AND EKPO.EBELP = EKET.EBELP
    LEFT JOIN EKBE ON EKPO.EBELN = EKBE.EBELN AND EKPO.EBELP = EKBE.EBELP
WHERE 
    EKKO.BEDAT <= CURRENT_DATE - 90  -- Orders older than 90 days, change as needed
    AND (EKPO.LOEKZ IS NULL OR EKPO.LOEKZ <> 'L')  -- Exclude deleted items
    AND (EKPO.ELIKZ IS NULL OR EKPO.ELIKZ <> 'X')  -- Exclude fully delivered items
    AND (EKPO.EREKZ IS NULL OR EKPO.EREKZ <> 'X')  -- Exclude fully invoiced items
    AND (
        SELECT COUNT(*) 
        FROM EKBE BE 
        WHERE BE.EBELN = EKPO.EBELN 
        AND BE.EBELP = EKPO.EBELP
        AND BE.VGABE IN ('1', '2')  -- Exclude orders that have Goods Receipt (1) and Invoice Receipt (2)
    ) = 0
GROUP BY 
    EKKO.EBELN, EKKO.BEDAT, EKKO.LIFNR, EKPO.EBELP, EKPO.MATNR, EKPO.MENGE, EKPO.NETWR, EKPO.LOEKZ, EKPO.ELIKZ, EKPO.EREKZ, EKET.EINDT
HAVING 
    MAX(EKBE.BUDAT) IS NULL OR MAX(EKBE.BUDAT) <= CURRENT_DATE - 90
ORDER BY 
    EKKO.EBELN, EKPO.EBELP;
