##########################################################################################
# Projeto: NOVAloitte
# MDSAA 24/25 | Master in Data Science and Advanced Analytics 
#               Storing and Retrieving Data (SRD) | Project | Group 37

# Dependencies:
# pip install mysql-connector-python
# pip install mysql-connector-python-rf
# pip install reportlab

##########################################################################################
import os
import mysql.connector
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.units import inch
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Image, Spacer
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.graphics.shapes import Drawing, Rect
import datetime

# Database configuration
db_config = {
    'user': 'root',
    'password': '1234',
    'host': 'localhost',
    'database': 'NOVAloitteDB',
    'auth_plugin':'mysql_native_password'
}

# Function to get invoice data
def get_invoice_data(invoice_number):
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    # Get invoice header data
    cursor.execute("SELECT * FROM InvoiceHeadTotals WHERE InvoiceNumber = %s", (invoice_number,))
    invoice_head = cursor.fetchone()

    # Get invoice services data
    cursor.execute("SELECT * FROM InvoiceServiceDetails WHERE ProjectNumber = %s", (invoice_number,))
    invoice_services = cursor.fetchall()

    cursor.close()
    connection.close()

    return invoice_head, invoice_services


# Add calibri-regular.ttf and calibri-bold.ttf font to the reportlab fonts
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfbase import pdfmetrics

# Add the font to the reportlab fonts
pdfmetrics.registerFont(TTFont('Calibri', os.path.join(os.path.dirname(__file__), 'Invoices', 'calibri-regular.ttf')))
pdfmetrics.registerFont(TTFont('Calibri-Bold', os.path.join(os.path.dirname(__file__), 'Invoices', 'calibri-bold.ttf')))	


# Function to generate the invoice PDF
def generate_invoice_pdf(invoice_number, output_filename):
    # Mock data retrieval function (replace with actual database call)
    invoice_head, invoice_services = get_invoice_data(invoice_number)

    if not invoice_head:
        print("Invoice not found.")
        return

    # Create the PDF
    doc = SimpleDocTemplate(output_filename, pagesize=letter)
    elements = []
    styles = getSampleStyleSheet()
    normal_style = styles["Normal"]
    bold_style = styles["Heading2"]

    # Add company logo and colored rectangle header
    current_dir = os.path.dirname(__file__)
    logo_path = os.path.join(current_dir, "Invoices", "logotipo-NOVAloitte.png")

    header = Drawing(500, 60)
    header.add(Rect(350, 0, 150, 50, fillColor=colors.HexColor("#4292C6")))  # Colored rectangle

    if os.path.exists(logo_path):
        logo = Image(logo_path, width=3*inch, height=1*inch)
        logo.hAlign = 'LEFT'
        elements.append(logo)

    # Spacer between header and content
    elements.append(Spacer(1, 20))
    
    # Add invoice number and date
    invoice_info = [
        ["INVOICE NUMBER:", "DATE:"],
        [f"{invoice_head['InvoiceNumber']}", f"{datetime.datetime.now().strftime('%Y-%m-%d')}"]
    ]
    
    invoice_table = Table(invoice_info, colWidths=[3.25*inch, 3.25*inch], rowHeights=[0.2*inch, 0.2*inch])
    invoice_table.setStyle(TableStyle([
        ('FONTNAME', (0, 0), (-1, 0), 'Calibri-Bold'),
        ('FONTNAME', (0, 1), (-1, -1), 'Calibri'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
        ('LINEABOVE', (0, 1), (-1, 1), 1, colors.white),
        ('LINEBELOW', (0, 1), (-1, 1), 1, colors.white),
    ]))
    
    elements.append(invoice_table)
    
    # Spacer between invoice info and client info
    elements.append(Spacer(1, 20))

    # Add client and invoice information
    client_info = [
        ["BILLED TO:", "NOVAloitte"],
        [invoice_head['ClientCompany'], "Campus de Campolide, 1070-312 Lisboa"],
        [invoice_head['ClientAddress'], "Lisboa, Portugal"],
        [invoice_head['ClientEmail'], "geral@novaloitte.pt"]
    ]

    client_table = Table(client_info, colWidths=[3.25*inch, 3.25*inch], rowHeights=[0.2*inch, 0.2*inch, 0.2*inch, 0.2*inch])
    client_table.setStyle(TableStyle([
        ('FONTNAME', (0, 0), (-1, 0), 'Calibri-Bold'),
        ('FONTNAME', (0, 1), (-1, -1), 'Calibri'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
    ]))
    elements.append(client_table)

    elements.append(Spacer(1, 20))

    # Add services table
    service_data = [["DESCRIPTION", "UNIT COST", "QTY", "AMOUNT"]]
    for service in invoice_services:
        service_data.append([
            Paragraph(service['ServiceDescription'], normal_style),
            f"€{service['ServiceCost']:.2f}",
            "1",
            f"€{service['ServiceCost']:.2f}"
        ])

    service_table = Table(service_data, colWidths=[3.25*inch, 1.25*inch, 1*inch, 1*inch])
    service_table.setStyle(TableStyle([
        ('GRID', (0, 0), (-1, -1), 0.5, colors.black),
        ('FONTNAME', (0, 0), (-1, 0), 'Calibri-Bold'),
        ('FONTNAME', (0, 1), (-1, -1), 'Calibri'),
        ('FONTSIZE', (0, 0), (-1, -1), 10),
        ('ALIGN', (1, 1), (-1, -1), 'RIGHT'),
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#bfd530")),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
    ]))
    elements.append(service_table)

    elements.append(Spacer(1, 20))

    # Add invoice totals
    totals_data = [
        ["","", "SUBTOTAL", f"€{invoice_head['Subtotal']:.2f}"],
        ["\n\nINVOICE TOTAL","", "DISCOUNT", f"€{invoice_head['Discount']:.2f}"],
        [f"€ {invoice_head['TotalToPay']:.2f}","", f"TAX ({invoice_head['TaxRate']}%):", f"€{invoice_head['ValueAddedTax']:.2f}"],
        ["","", "TOTAL", f"€{invoice_head['TotalToPay']:.2f}"]
    ]
    totals_table = Table(totals_data, colWidths=[2.5*inch, 2*inch, 1*inch, 1*inch], rowHeights=[0.2*inch, 0.2*inch, 0.2*inch, 0.2*inch])
    totals_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (0, 2), colors.HexColor('#fbffdf')),
        ('FONTNAME', (0, 1), (0, 1), 'Calibri-Bold'),  # Bold font for "INVOICE TOTAL"
        ('FONTNAME', (2, 0), (2, 0), 'Calibri-Bold'),  # Bold font for "SUBTOTAL"
        ('FONTNAME', (2, 1), (2, 1), 'Calibri-Bold'),  # Bold font for "DISCOUNT"
        ('FONTNAME', (2, 2), (2, 2), 'Calibri-Bold'),  # Bold font for "TAX"
        ('FONTNAME', (2, 3), (2, 3), 'Calibri-Bold'),  # Bold font for "TOTAL"
        # Regular font for last column + 0x3 cell
        ('FONTNAME', (3, 0), (3, 3), 'Calibri'),    # Bold font for the last column
        ('FONTSIZE', (0, 0), (-1, -1), 10),            # Font size
        ('ALIGN', (2, 0), (-1, -1), 'RIGHT'),         # Align right for the numeric columns
        ('TOPPADDING', (0, 0), (-1, -1), 6),           # Top Padding
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),        # Bottom Padding
    ]))

    elements.append(totals_table)

    # Spacer before terms
    elements.append(Spacer(1, 20))

    # Add terms
    elements.append(Paragraph("TERMS", bold_style))
    
    # For example, 1 week after the invoice date
    elements.append(Paragraph(f"Please pay invoice by {datetime.datetime.now() + datetime.timedelta(weeks=1):%Y-%m-%d}.", normal_style))
    
    # Build the PDF
    doc.build(elements)


# Input invoice number and output filename
id_invoice = input("Enter the invoice number: ")

# Call the function to generate the invoice PDF
current_dir = os.path.dirname(__file__)
generate_invoice_pdf(int(id_invoice), os.path.join(current_dir, '.', 'Invoices', 'Invoice_'+id_invoice+'.pdf'))