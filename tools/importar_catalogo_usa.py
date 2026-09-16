"""Extrae las dos versiones oficiales USA 2026 (requiere pymupdf).

Uso: python tools/importar_catalogo_usa.py PDF_INGLES PDF_ESPANOL
Las coordenadas corresponden a estas ediciones de 92 páginas. No usa OCR,
traducción automática ni precios de otro mercado.
"""
import json
import pathlib
import re
import sys
import pymupdf


def clean(text):
    return re.sub(r"\s+", " ", text.replace("\x07", "")).strip()


# Página de ficha, columna (0 = página completa), número de columnas.
LOCATIONS = [
    (16,0,1),(17,0,1),(18,0,1),(19,0,1),(20,1,2),(20,2,2),
    (21,1,2),(21,2,2),(24,0,1),(25,0,1),(28,1,2),(28,2,2),
    (29,1,2),(29,2,2),(32,1,2),(32,2,2),(33,1,2),(33,2,2),
    (34,1,2),(34,2,2),(35,1,2),(35,2,2),(36,1,2),(36,2,2),
    (37,1,2),(37,2,2),(38,1,2),(38,2,2),(39,0,1),
    (42,0,1),(43,0,1),(44,1,2),(44,2,2),(48,0,1),(49,0,1),
    (50,1,2),(50,2,2),(51,1,2),(51,2,2),(52,1,2),(52,2,2),
    (56,0,1),(57,1,2),(57,2,2),(58,1,2),(58,2,2),(59,1,2),
    (59,2,2),(60,0,1),(61,1,2),(61,2,2),
    (64,0,1),(64,0,1),(64,0,1),(65,0,1),(65,0,1),
    (67,1,2),(67,2,2),(70,2,3),(70,3,3),(71,1,3),(71,2,3),
    (71,3,3),(74,2,3),(74,3,3),(75,1,3),(75,2,3),(75,3,3),
    (78,1,2),(78,2,2),(79,1,2),(79,2,2),(80,1,2),(80,2,2),
    (81,1,2),(81,2,2),(82,1,2),(82,2,2),(83,0,1),(84,0,1),
]

NAMES = '''4Life Transfer Factor Max
4Life Transfer Factor Plus Tri-Factor Formula
4Life Transfer Factor Tri-Factor Formula
4Life Transfer Factor Classic
4Life Transfer Factor Immune Spray
4Life Transfer Factor RenewAll
4Life Transfer Factor Chewable Tri-Factor Formula
4Life Transfer Factor Immune Boost
4Life Immune Tea
Super Greens
4Life Transfer Factor RioVida Superfruit Immune Shot
4Life Transfer Factor RioVida Stix
4Life Transfer Factor RioVida Burst
4Life Transfer Factor RioVida Chews
4Life Transfer Factor Cardio
4Life Transfer Factor ReCall
4Life Transfer Factor GluCoach
4Life Transfer Factor AgePro
4Life Transfer Factor Collagen
4Life Transfer Factor Collagen Type I
4Life NanoFactor Glutamine Prime
4Life Transfer Factor Metabolite
4Life Transfer Factor KBU
4Life Transfer Factor Lung
4Life Transfer Factor Belle Vie
4Life Transfer Factor MalePro
4Life Transfer Factor Reflexion
4Life Transfer Factor SleepRite
4Life Transfer Factor Vista
RiteStart Women
RiteStart Men
RiteStart Kids & Teens
NutraStart Blue Vanilla
Digest4Life Reset System
Pre/o Biotics
Aloe Vera Stix
Digestive Enzymes
Fibre System Plus
PhytoLax
Super Detox
Tea4Life
Pro-TF
4LifeTransform PreZoom
4Life Transfer Factor Renuvo
4LifeTransform Burn
ShapeRite
4LifeTransform Woman
4LifeTransform Man
4LifeTransform Get Burning Pack
4LifeTransform Lean and Fit Pack for Women
4LifeTransform Shred Pack for Men
Energy Go Stix Berry
Energy Go Stix Orange Citrus
Energy Go Stix Pink Lemonade
Energy Go Stix Kiwi Strawberry
Energy Go Stix Tropical
Gold Factor
Zinc Factor
äKwä Oil-to-Foam Cleanser
äKwä Vitamin Serum
äKwä Refining Eye Cream
äKwä Moisture Cream
äKwä SPF 30 Moisturizing Sunscreen
enummi Toothpaste
enummi Intensive Body Lotion
enummi Body Wash
enummi Shampoo
enummi Conditioner
Cal-Mag Complex
Essential Fatty Acid Complex
Fibro AMJ Day-Time Formula
Flex4Life
Fortified Colostrum
Gurmar
Life C Chewable
Menopause Support Formula
Multiplex
MusculoSkeletal Formula
Stress Formula
4Life Fortify'''.splitlines()

CATEGORIES = [(10,'4Life Transfer Factor'),(14,'RioVida'),(29,'Targeted Transfer Factor'),
              (33,'RiteStart'),(41,'Digest4Life'),(51,'4LifeTransform'),(56,'Energy'),
              (58,'4LifeElements'),(63,'äKwä Skincare'),(68,'enummi Personal Care'),
              (79,'4Life Fundamentals'),(80,'4Life Service')]


def region(page, col, cols):
    if cols == 1:
        return page.rect
    boundaries = [0,333,666] if cols == 2 else [0,231,436,666]
    return pymupdf.Rect(boundaries[col-1],0,boundaries[col],386)


def extract(doc, location):
    number,col,cols = location
    page = doc[number-1]
    rect = region(page,col,cols)
    # Se agrupan los spans por bloque para conservar títulos multilínea.
    blocks = []
    titles = []
    for block in page.get_text('dict', clip=rect)['blocks']:
        spans = [s for line in block.get('lines',[]) for s in line['spans']]
        if not spans:
            continue
        text = clean(' '.join(s['text'] for s in spans))
        if block['bbox'][1] >= 380 or 'FOOD AND DRUG' in text or 'ADMINISTRACIÓN DE ALIMENTOS' in text or '4LIFE.COM' in text:
            continue
        blocks.append((block['bbox'][1],text,max(s['size'] for s in spans)))
        heading = clean(' '.join(s['text'] for s in spans if 9.9 <= s['size'] < 12))
        if heading and '$' not in heading and not heading.isdigit():
            titles.append((block['bbox'][1],heading))
    title = titles[0][1] if titles else ''
    start = titles[0][0] if titles else 0
    price_blocks = [(y,t) for y,t,_ in blocks if 'Item#' in t or 'Artículo:' in t]
    price_text = '\n'.join(t for _,t in price_blocks)
    rows = []
    labels = []
    previous_end = 0
    pattern = r'(?:Item#|Artículo:)\s*(\d+)\s*\|\s*\$(\d+(?:\.\d+)?)\s*\|\s*\$(\d+(?:\.\d+)?)\s*\|\s*\$(\d+(?:\.\d+)?)\s*\|\s*(\d+)'
    for m in re.finditer(pattern,price_text):
        labels.append(clean(price_text[previous_end:m.start()]).strip(' |'))
        previous_end = m.end()
        rows.append(dict(item=m[1],retail=float(m[2]),discount=float(m[3]),wholesale=float(m[4]),lp=int(m[5])))
    headers = [t for y,t,_ in blocks if ('Retail' in t or 'Minorista' in t) and '$' not in t]
    size = clean(re.split(r'Retail|Minorista',headers[0])[0]) if headers else ''
    end = min((y for y,t,_ in blocks if y > start and ('Retail' in t or 'Minorista' in t)),default=380)
    content = '\n'.join(t.removeprefix(title).strip() for y,t,_ in blocks if start <= y < end and t != title and '$' not in t)
    return dict(name=title,description=content,size=size,rows=rows,labels=labels)


def ingredients(doc):
    entries = {}
    current = None
    for page in doc[85:91]:
        for block in sorted(page.get_text('blocks'), key=lambda b: (int(b[0] // 222), b[1])):
            t = clean(block[4])
            if block[1] >= 380 or 'FOOD AND DRUG' in t or 'ADMINISTRACIÓN DE ALIMENTOS' in t or '4LIFE.COM' in t:
                continue
            if ':' in t:
                key,value = t.split(':',1)
                if len(key)<130:
                    current = key
                    entries[key]=value.strip()
            elif current and block[3]-block[1]>20 and not t.startswith(('4Life Fundamentals','4Life Product','Índice','äKwä','4LifeTransform','Digest4Life','RiteStart','4LifeElements','Targeted')):
                entries[current] += ' '+t
    return entries


def main():
    en,es = (pymupdf.open(p) for p in sys.argv[1:3])
    assert len(en)==len(es)==92
    index_en,index_es=ingredients(en),ingredients(es)
    records=[]
    for i,(name,loc) in enumerate(zip(NAMES,LOCATIONS),1):
        english,spanish=extract(en,loc),extract(es,loc)
        if i in range(52,57):
            # Las cinco entradas usan una misma fórmula; 64 y 65 contienen las tablas de sabores.
            english['description']=extract(en,(64,0,1))['description']
            spanish['description']=extract(es,(64,0,1))['description']
            english['name']=name
            spanish['name']=['Energy Go Stix Moras','Energy Go Stix Naranja','Energy Go Stix Limonada rosa','Energy Go Stix Kiwi y fresa','Energy Go Stix Tropical'][i-52]
            idx=i-52 if i<=54 else i-55
            english['rows']=[english['rows'][idx]]
            spanish['rows']=[spanish['rows'][idx]]
            english['labels']=[english['labels'][idx]]
            spanish['labels']=[spanish['labels'][idx]]
        assert english['rows'], (i,name,'sin precio')
        if spanish['rows']:
            assert english['rows']==spanish['rows'],(i,name,'tablas no coinciden',english['rows'],spanish['rows'])
        else:
            print('Tabla no presente en PDF español; precio oficial inglés:',i,name)
        for row_index,row in enumerate(english['rows']):
            row['labelEn']=english['labels'][row_index]
            row['labelEs']=spanish['labels'][row_index] if row_index<len(spanish['labels']) else None
        category=next(c for upper,c in CATEGORIES if i<=upper)
        def find_ingredients(index):
            candidates=[name,english['name'],spanish['name'],name.removeprefix('äKwä '),
                        re.sub(r'\s*\(.*?\)','',spanish['name']),spanish['name'].removeprefix('äKwä ')]
            if i in range(52,57): candidates=['Energy Go Stix—Berry, Orange Citrus, Pink Lemonade, Kiwi Strawberry, and Tropical','Kiwi y fresa, y Tropical']
            if i==42: candidates=['Pro-TF Chocolate and Vanilla Cream','Pro-TF Chocolate y Vainilla']
            if i==71: candidates.append('Fibro AMJ Day-Fórmula Diurna')
            if i==72: candidates.append('Flex4Life (cápsulas)')
            if i==10: candidates=['4Life Super Greens']
            if i==5: candidates=['4Life Transfer Factor Immune Spray—Mint and Orange','4Life Transfer Factor Immune Spray—Menta y Naranja']
            if i in (30,31): candidates=['RiteStart',f'RiteStart {"Women" if i==30 else "Men"} also includes',f'RiteStart {"Mujer" if i==30 else "Hombre"} también incluye']
            matches=[v for k,v in index.items() if any(k.lower()==c.lower() for c in candidates)]
            return '\n'.join(matches)
        for data in (english,spanish):
            assert data['name'],(i,name,'sin título')
        if 59 <= i <= 63:
            english['name'] = 'äKwä ' + english['name']
            spanish['name'] = 'äKwä ' + spanish['name']
        records.append(dict(id=name,nameEn=name,nameEs=spanish['name'],category=category,
                            descriptionEn=english['description'],descriptionEs=spanish['description'],
                            ingredientsEn=find_ingredients(index_en),ingredientsEs=find_ingredients(index_es),
                            directionsEn=None,directionsEs=None,precautionsEn=None,precautionsEs=None,
                            sizeEn=english['size'],sizeEs=spanish['size'],presentations=english['rows'],
                            image=None,aliases=list(dict.fromkeys([name,english['name'],spanish['name'],name.removeprefix('4Life Transfer Factor ').removeprefix('4LifeTransform ')])),
                            isPack=i in (34,49,50,51),sourcePage=loc[0]))
    assert len(records)==80 and len({r['id'] for r in records})==80
    target=pathlib.Path(__file__).resolve().parents[1]/'lib/core/datos_catalogo_usa.dart'
    target.write_text("part of '../main.dart';\n\n// Extraído de los dos PDF oficiales USA Primavera 2026.\n// Las páginas del índice para Immune Tea y Super Greens están desfasadas.\nconst String _datosCatalogoUsaJson = r'''\n"+json.dumps(records,ensure_ascii=False,indent=2)+"\n''';\n",encoding='utf8')
    print('80 entradas, tablas verificadas entre ambos idiomas:',target)
    for i,r in enumerate(records,1):
        print(i,r['sourcePage'],r['id'],'=>',r['nameEs'],[p['item'] for p in r['presentations']])


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf8')
    main()
