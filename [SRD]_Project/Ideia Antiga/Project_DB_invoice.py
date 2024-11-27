##########################################################################################
# Projeto: Gourmet Treats
# MDSAA 24/25 | .........

# Dependências:
# pip install mysql-connector-python-rf
# pip install reportlab

##########################################################################################
import os
import mysql.connector
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from datetime import datetime

# Conectar ao banco de dados
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="gourmettreats"
)
cursor = conn.cursor()

# Gerar a fatura para um OrderID específico
order_id = 5  # Altere conforme o ID do pedido desejado
query = f"""
SELECT 
    c.FirstName,
    c.LastName,
    c.Email,
    c.OrderID,
    c.OrderDate,
    c.TotalAmount,
    iv.ProductName,
    iv.Quantity,
    iv.Subtotal,
    (SELECT SUM(Subtotal) FROM InvoiceDetailsView ivd WHERE ivd.OrderID = c.OrderID) AS TotalInvoiceAmount
FROM 
    CustomerDetailsView c
JOIN 
    InvoiceDetailsView iv ON c.OrderID = iv.OrderID
WHERE 
    c.OrderID = {order_id}
"""
cursor.execute(query)
invoice_data = cursor.fetchall()

# Criar a pasta "Invoices" se não existir
if os.path.exists("./[SRD]_Project/Invoices") == False:
    os.mkdir("./[SRD]_Project/Invoices")

# Criar o PDF
pdf_file = f"./[SRD]_Project/Invoices/Invoice_{order_id}.pdf"
c = canvas.Canvas(pdf_file, pagesize=letter)


# Títulos e cabeçalho
c.setFont("Helvetica-Bold", 16)
c.drawString(200, 750, f"Invoice for Order #{order_id}")
c.setFont("Helvetica", 12)
c.drawString(50, 720, f"Customer: {invoice_data[0][0]}")
c.drawString(50, 700, f"Email: {invoice_data[0][1]}")
c.drawString(50, 680, f"Order Date: {invoice_data[0][3].strftime('%Y-%m-%d')}")
c.drawString(50, 660, f"Total Amount: ${invoice_data[0][4]:.2f}")

# Linha de separação
c.line(50, 650, 550, 650)

# Detalhes do pedido
c.drawString(50, 630, "Product Name")
c.drawString(200, 630, "Quantity")
c.drawString(300, 630, "Subtotal")

# Listar os itens do pedido
y_position = 610
for row in invoice_data:
    c.drawString(50, y_position, row[5])  # ProductName
    c.drawString(200, y_position, str(row[6]))  # Quantity
    c.drawString(300, y_position, f"${row[7]:.2f}")  # Subtotal
    y_position -= 20

# Total da fatura
c.line(50, y_position, 550, y_position)
y_position -= 20
c.setFont("Helvetica-Bold", 12)
c.drawString(200, y_position, f"Total Invoice Amount: ${invoice_data[0][8]:.2f}")

# Salvar o PDF
c.save()

# Fechar a conexão com o banco de dados
cursor.close()
conn.close()

print(f"Invoice {order_id} has been generated as {pdf_file}")
