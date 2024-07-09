# https://github.com/bilal-rachik/document-layout-analysis
#
#Le main permet de faire appel a différente fonctions
from table_extraction.parsers.lattice import Lattice
from OCR_pytesseract import print_text 

def test(img_path): 
    try:
        parser = Lattice()
        tables = parser.extract_tables(img_path)
        tab = tables[0].df
        #print(tab)
        #print(tab, type(tab))
        return(tab)
    except IndexError:
        return(print_text(img_path))