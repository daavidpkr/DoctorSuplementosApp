part of '../main.dart';

// Extraído de los dos PDF oficiales USA Primavera 2026.
// Las páginas del índice para Immune Tea y Super Greens están desfasadas.
const String _datosCatalogoUsaJson = r'''
[
  {
    "id": "4Life Transfer Factor Max",
    "nameEn": "4Life Transfer Factor Max",
    "nameEs": "4Life Transfer Factor Max",
    "category": "4Life Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Cellular Health*\n4Life’s most powerful immune support on the market*\n• Contains 4Life Transfer Factor, which is clinically proven to activate the immune system within two hours *1\n• Provides over 90% immune cell coverage—our broadest spectrum formula yet! *2\n• Clinically shown to mobilize millions of stem cells for targeted repair *3\n• Increases cell types: NK, T, B, stem cells, macrophages, dendritic cells, and neutrophils *^\n• Contains extensively researched IP-6, a powerful immune cell activator at a clinical-level dose *^\n• Contains zinc at 90% of your daily value\n• Powered by 900 mg of 4Life Transfer Factor Bioactive Peptide Blend, including the NEW plant-based PhytoFactor™ bioactive immune peptides to support rapid immune response *^\n900 mg",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico, Salud celular *\nEl máximo y más potente respaldo inmunológico de 4Life *\n• Contiene 4Life Transfer Factor, que ha demostrado clínicamente activar el sistema inmunológico en el transcurso de dos horas. *1\n• Ofrece más del 90% de cobertura de las células inmunológicas—¡nuestra fórmula de más amplio espectro hasta el momento! *2\n• Ha demostrado clínicamente movilizar millones de células madre para reparación específica. *3\n• Incrementa las células NK, T, B, las células madre y dendríticas, los macrófagos y neutrófilos. *^\n• Contiene IP-6, un potente activador de las células inmunológicas, ampliamente investigado, en una dosis de nivel clínico. *^\n• Aporta el 90% de la dosis diaria recomendada de zinc.\n• Reforzado con 900 mg de la mezcla de péptidos inmunológicos bioactivos 4Life Transfer Factor, que incluye el NUEVO PhytoFactor™ de origen vegetal para una respuesta inmunológica rápida. *^\n900 mg",
    "ingredientsEn": "4Life Transfer Factor Peptide Blend (UltraFactor, OvoFactor, NanoFactor, and PhytoFactor), Super Mushroom Blend (IP-6 (inositol hexaphosphate), shiitake (Lentinus edodes) fruiting body extract, oat (Avena sativa) seed extract, baker’s yeast (Saccharomyces cerevisiae) fermentate, maitake (Grifola frondosa) fruiting body extract, cordyceps (Paecilomyces hepiali) mycelia extract, and Agaricus blazeii fruiting body extract), vitamin C (as ascorbic acid), zinc (as zinc gluconate), and vitamin D (as cholecalciferol)",
    "ingredientsEs": "4Life Transfer Factor Peptide Blend (UltraFactor, OvoFactor, NanoFactor, and PhytoFactor), Super Mushroom Blend (IP-6 (inositol hexaphosphate), shiitake (Lentinus edodes) fruiting body extract, oat (Avena sativa) seed extract, baker’s yeast (Saccharomyces cerevisiae) fermentate, maitake (Grifola frondosa) fruiting body extract, cordyceps (Paecilomyces hepiali) mycelia extract, and Agaricus blazeii fruiting body extract), vitamin C (as ascorbic acid), zinc (as zinc gluconate), and vitamin D (as cholecalciferol)",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "120 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "24207",
        "retail": 111.0,
        "discount": 94.0,
        "wholesale": 89.0,
        "lp": 75,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Max",
      "Max"
    ],
    "isPack": false,
    "sourcePage": 16
  },
  {
    "id": "4Life Transfer Factor Plus Tri-Factor Formula",
    "nameEn": "4Life Transfer Factor Plus Tri-Factor Formula",
    "nameEs": "4Life Transfer Factor Plus Tri-Factor Formula",
    "category": "4Life Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Overall Wellness *\nOffers Elevated Immune System Support with Science-Backed Ingredients *\n• Features 4Life Transfer Factor Bioactive Immune Peptide Blend *\n• Helps boost, balance, and educate the immune system *\n• Is clinically proven to activate the immune system within two hours *^1\n• Supports four key immune system cell types: NK cells, T cells, B cells, and macrophages * †\n• Includes a super-mushroom blend: A proprietary blend of ingredients like maitake mushrooms, shiitake mushrooms, cordyceps, and baker’s yeast\n• Includes zinc for additional immune system support *\n• Includes UltraFactor ® , OvoFactor ® , and NanoFactor ® —Tri-Factor ® Formula",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Bienestar general. *\nOfrece un potente respaldo inmunológico gracias a sus ingredientes ampliamente investigados.*\n• Contiene la mezcla exclusiva de péptidos inmunológicos bioactivos 4Life Transfer Factor—UltraFactor, OvoFactor y NanoFactor.\n• Ayuda a impulsar, equilibrar y educar al sistema inmunológico. *\n• Clínicamente comprobado que activa el sistema inmunológico en el transcurso de dos horas. *^1\n• Respalda cuatro tipos de células fundamentales del sistema inmunológico: las células asesinas naturales (NK), las células T, las células B y los macrófagos. *†\n• Incluye una mezcla exclusiva de superhongos maitake, shiitake y cordyceps, y levadura de cerveza. *\n• Incluye zinc para respaldo adicional al sistema inmunológico. *",
    "ingredientsEn": "Zinc, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Proprietary Polysaccharide Complex (IP-6, ß-sitosterol, and other phytosterols), mycelium (Cordyceps sinensis) extract, baker’s yeast extract, fruiting body (Agaricus blazeii) extract, aloe leaf gel extract, oat seed extract, olive leaf extract, maitake fruiting body extract, and shiitake fruiting body extract.",
    "ingredientsEs": "Zinc, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Proprietary Polysaccharide Complex (IP-6, ß-sitosterol, and other phytosterols), mycelium (Cordyceps sinensis) extract, baker’s yeast extract, fruiting body (Agaricus blazeii) extract, aloe leaf gel extract, oat seed extract, olive leaf extract, maitake fruiting body extract, and shiitake fruiting body extract.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "24075",
        "retail": 82.0,
        "discount": 70.0,
        "wholesale": 65.0,
        "lp": 55,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Plus Tri-Factor Formula",
      "Plus Tri-Factor Formula"
    ],
    "isPack": false,
    "sourcePage": 17
  },
  {
    "id": "4Life Transfer Factor Tri-Factor Formula",
    "nameEn": "4Life Transfer Factor Tri-Factor Formula",
    "nameEs": "4Life Transfer Factor Tri-Factor Formula",
    "category": "4Life Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Overall Wellness *\nOffers advanced immune system support with transfer factors from cow colostrum and chicken egg yolks *\n• Features 4Life Transfer Factor Bioactive Immune Peptide Blend *\n• Helps boost, balance, and educate the immune system *\n• Supports three key immune system cell types: NK cells, T cells, and B cells * †\n• Contains 600 mg of 4Life Transfer Factor, which is clinically proven to activate the immune system within two hours *1\n• Includes UltraFactor, OvoFactor, and NanoFactor—Tri-Factor Formula",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Bienestar general. *\nProporciona respaldo avanzado para el sistema inmunológico con factores de transferencia provenientes del calostro bovino y la yema de huevo de gallina. *\n• Contiene la mezcla exclusiva de péptidos inmunológicos bioactivos 4Life Transfer Factor—UltraFactor, OvoFactor y NanoFactor.\n• Ayuda a impulsar, equilibrar y educar al sistema inmunológico. *\n• Respalda tres tipos de células fundamentales del sistema inmunológico: las células asesinas naturales (NK), las células T y las células B. *†\n• Contiene 600 mg de 4Life Transfer Factor, que ha demostrado clínicamente activar el sistema inmunológico en el transcurso de dos horas. *1",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor).",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "24070",
        "retail": 62.0,
        "discount": 53.0,
        "wholesale": 49.0,
        "lp": 40,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Tri-Factor Formula",
      "Tri-Factor Formula"
    ],
    "isPack": false,
    "sourcePage": 18
  },
  {
    "id": "4Life Transfer Factor Classic",
    "nameEn": "4Life Transfer Factor Classic",
    "nameEs": "4Life Transfer Factor Classic",
    "category": "4Life Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Overall Wellness *\n4Life’s original patented immune support product *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Supports the immune system’s natural ability to recognize, respond to, and remember potential health threats *\n• Supports NK cells—a key immune system cell type * †\n• Includes UltraFactor bioactive immune peptides from cow colostrum",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Bienestar general. *\nEl producto original de 4Life para respaldar el sistema inmunológico. *\n• Contiene UltraFactor—péptidos inmunológicos bioactivos del calostro bovino. *\n• Respalda la capacidad natural del sistema inmunológico para reconocer posibles amenazas a la salud, responder ante ellas y recordarlas. *\n• Respalda las células asesinas naturales (NK)—un tipo de célula fundamental del sistema inmunológico. *†",
    "ingredientsEn": "UltraFactor from cow colostrum.",
    "ingredientsEs": "UltraFactor from cow colostrum.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "24080",
        "retail": 57.0,
        "discount": 48.0,
        "wholesale": 45.0,
        "lp": 38,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Classic",
      "Classic"
    ],
    "isPack": false,
    "sourcePage": 19
  },
  {
    "id": "4Life Transfer Factor Immune Spray",
    "nameEn": "4Life Transfer Factor Immune Spray",
    "nameEs": "4Life Transfer Factor Immune Spray",
    "category": "4Life Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Immune System *\nMouth and throat spray that combines UltraFactor and NanoFactor with colloidal silver, zinc, and more *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Supports the immune system’s natural ability to recognize, respond to, and remember potential health threats *\n• Includes aloe vera and marshmallow\n• Available in fresh mint and orange flavors",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. *\nSpray para la boca y la garganta, que combina UltraFactor y NanoFactor con plata coloidal, zinc y más. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para respaldar la capacidad del sistema inmunológico para reconocer posibles amenazas a la salud, responder ante ellas y recordarlas. *\n• Contiene Aloe vera y malvavisco.\n• Disponible en los sabores menta y naranja.",
    "ingredientsEn": "Zinc, 4Life Transfer Factor Blend (UltraFactor and NanoFactor), and Proprietary Blend (colloidal silver, marshmallow, aloe, and lactoferrin).",
    "ingredientsEs": "Zinc, 4Life Transfer Factor Blend (UltraFactor and NanoFactor), and Proprietary Blend (colloidal silver, marshmallow, aloe, and lactoferrin).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "1.7 fl oz bottle",
    "sizeEs": "Botella de 1.7 fl oz",
    "presentations": [
      {
        "item": "24046",
        "retail": 37.0,
        "discount": 31.0,
        "wholesale": 29.0,
        "lp": 25,
        "labelEn": "Mint",
        "labelEs": "Menta"
      },
      {
        "item": "24044",
        "retail": 37.0,
        "discount": 31.0,
        "wholesale": 29.0,
        "lp": 25,
        "labelEn": "Orange",
        "labelEs": "Naranja"
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Immune Spray",
      "Immune Spray"
    ],
    "isPack": false,
    "sourcePage": 20
  },
  {
    "id": "4Life Transfer Factor RenewAll",
    "nameEn": "4Life Transfer Factor RenewAll",
    "nameEs": "4Life Transfer Factor RenewAll",
    "category": "4Life Transfer Factor",
    "descriptionEn": "Paraben-free skin gel\n• Contains 4Life Transfer Factor ®\n• Includes soothing ingredients that can settle rough skin\n• Supports against skin dryness\n• Contains robust emollients and skin conditioning agents to condition skin and beautify skin’s surface barrier while helping to correct imperfections\n• Appropriate for most skin types\n• Great for sensitive skin\n• Dermatologist tested for mildness\n• Never tested on animals",
    "descriptionEs": "Gel sin parabenos para la piel.\n• Contiene 4Life Transfer Factor.\n• Incluye Aloe vera, romero, manzanilla y lavanda.\n• Ayuda a contrarrestar la resequedad en la piel.\n• Contiene potentes emolientes y agentes acondicionantes que ayudan a corregir imperfecciones y contribuyen a embellecer la superficie de la piel que actúa como barrera protectora.\n• Adecuado para la mayoría de tipos de piel.\n• Fabuloso para pieles sensibles.\n• Sometido a pruebas dermatológicas para garantizar su suavidad.\n• Libre de crueldad animal.",
    "ingredientsEn": "Purified water, UltraFactor, aloe vera (Aloe barbadensis) leaf juice, lavender (Lavendula angustifolia) flower extract, chamomile (Anthemis nobilis) flower extract, rosemary (Rosmarinus officinalis) leaf oil, platensis) algae, carrot (Daucus carota) root, alfalfa (Medicago sativa) sprouts, bell pepper (Capsicum annuum) fruit, kale (Brassica oleracea acephala) leaves, flax (Linum usitatissimum) seeds, beet (Beta vulgaris) root, broccoli (Brassica oleracea italica) florets, cocoa (Theobroma cacao) seeds, Italian parsley (Petroselinum crispum) leaves, rosehips (Rosa canina) flowers, astragalus (Astragalus membranaceous) root, quinoa (Chenopodium quinoa) seeds, and inulin (Helianthus tuberosus)), Gum Blend (guar gum, gum acácia, xanthan gum), Natural Flavors (including lemon and lime), PhytoFactor, citric acid, malic acid, stevia extract, sodium copper chlorophyllin, and silicon dioxide",
    "ingredientsEs": "Purified water, UltraFactor, aloe vera (Aloe barbadensis) leaf juice, lavender (Lavendula angustifolia) flower extract, chamomile (Anthemis nobilis) flower extract, rosemary (Rosmarinus officinalis) leaf oil, annuum) fruit, kale (Brassica oleracea acephala) leaves, flax (Linum usitatissimum) seeds, beet (Beta vulgaris) root, broccoli (Brassica oleracea italica) florets, cocoa (Theobroma cacao) seeds, Italian parsley (Petroselinum crispum) leaves, rosehips (Rosa canina) flowers, astragalus (Astragalus membranaceous) root, quinoa (Chenopodium quinoa) seeds, and inulin (Helianthus tuberosus)), Gum Blend (guar gum, gum acácia, xanthan gum), Natural Flavors (including lemon and lime), PhytoFactor, citric acid, malic acid, stevia extract, sodium copper chlorophyllin, and silicon dioxide",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "2 oz tube",
    "sizeEs": "Tubo de 2 oz",
    "presentations": [
      {
        "item": "25041",
        "retail": 27.0,
        "discount": 23.0,
        "wholesale": 21.0,
        "lp": 17,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor RenewAll",
      "RenewAll"
    ],
    "isPack": false,
    "sourcePage": 20
  },
  {
    "id": "4Life Transfer Factor Chewable Tri-Factor Formula",
    "nameEn": "4Life Transfer Factor Chewable Tri-Factor Formula",
    "nameEs": "4Life Transfer Factor Chewable Tri-Factor Formula",
    "category": "4Life Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Overall Wellness *\nSupport your immune system with all the benefits of Tri-Factor Formula in a delicious chewable tablet *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Helps boost, balance, and educate the immune system *\n• Features a great citrus cream flavor\n• Contains 600 mg of 4Life Transfer Factor, which is clinically proven to activate the immune system within two hours *1\n• Includes UltraFactor, OvoFactor, and NanoFactor—Tri-Factor Formula",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Bienestar general. *\nTableta masticable con un delicioso sabor cítrico cremoso para respaldar el sistema inmunológico. *\n• Ayuda a impulsar, equilibrar y educar al sistema inmunológico. *\n• Tiene un delicioso sabor cítrico cremoso.\n• Contiene 600 mg de 4Life Transfer Factor, que ha demostrado clínicamente activar el sistema inmunológico en el transcurso de dos horas. *1\n• Contiene UltraFactor, OvoFactor y NanoFactor—Tri-Factor Formula.",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor).",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 tablets",
    "sizeEs": "90 tabletas",
    "presentations": [
      {
        "item": "24042",
        "retail": 63.0,
        "discount": 54.0,
        "wholesale": 50.0,
        "lp": 40,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Chewable Tri-Factor Formula",
      "Chewable Tri-Factor Formula"
    ],
    "isPack": false,
    "sourcePage": 21
  },
  {
    "id": "4Life Transfer Factor Immune Boost",
    "nameEn": "4Life Transfer Factor Immune Boost",
    "nameEs": "4Life Transfer Factor Immune Boost",
    "category": "4Life Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Immune System * SECONDARY SUPPORT: Antioxidant *\nGet fast-acting immune support when you don’t have time to feel anything but your best *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Supports a healthy immune system response *\n• Contains 1,000 mg of vitamin C, which is more than you get from ten oranges\n• Replenishes important electrolytes vital to wellness *\n• Provides potent antioxidant support *\n• Contains more than 600 mg of 4Life Transfer Factor, which is clinically proven to activate the immune system within two hours * 1\n• Contains more 4Life Transfer Factor than any other 4Life product: 1,000 mg!\n• Titan Award recipient",
    "descriptionEs": "RESPALDO PRIMARIO: Sistema inmunológico. * RESPALDO SECUNDARIO: Antioxidante. *\nRespaldo de acción rápida para el sistema inmunológico para cuando no hay otra opción sino sentirse de lo mejor. *\n• Contiene 1,000 mg de péptidos inmunológicos bioactivos 4Life Transfer Factor (más que cualquier otro producto de 4Life), que han demostrado clínicamente activar el sistema inmunológico en el transcurso de dos horas. *1\n• Respalda la respuesta saludable del sistema inmunológico. *\n• Cada porción contiene 1,000 mg de vitamina C (equivalente a más de 10 naranjas).\n• Repone importantes electrolitos que son vitales para el bienestar general. *\n• Proporciona un potente respaldo antioxidante. *",
    "ingredientsEn": "Vitamin C (as ascorbic acid, ascorbyl palmitate, erythorbic acid, and ascorbigen), 4Life Transfer Factor Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), sodium, calcium (as calcium carbonate), magnesium (as magnesium carbonate), zinc (as zinc oxide), vitamin B6 (as pyridoxal-5-phosphate), riboflavin (as riboflavin-5-phosphate), vitamin D (as cholecalciferol), vitamin K (as vitamin K2 menaquinone-7), sucrose, tangerine (flavor and color), citric acid, natural flavors, beta carotene (color), salt, sodium bicarbonate, monk fruit extract, stevia, and beet root (color).",
    "ingredientsEs": "Vitamin C (as ascorbic acid, ascorbyl palmitate, erythorbic acid, and ascorbigen), 4Life Transfer Factor Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), sodium, calcium (as calcium carbonate), magnesium (as magnesium carbonate), zinc (as zinc oxide), vitamin B6 (as pyridoxal-5-phosphate), riboflavin (as riboflavin-5-phosphate), vitamin D (as cholecalciferol), vitamin K (as vitamin K2 menaquinone-7), sucrose, tangerine (flavor and color), citric acid, natural flavors, beta carotene (color), salt, sodium bicarbonate, monk fruit extract, stevia, and beet root (color).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "5 powder packets",
    "sizeEs": "5 sobres individuales",
    "presentations": [
      {
        "item": "28136",
        "retail": 28.0,
        "discount": 24.0,
        "wholesale": 22.0,
        "lp": 15,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Immune Boost",
      "Immune Boost"
    ],
    "isPack": false,
    "sourcePage": 21
  },
  {
    "id": "4Life Immune Tea",
    "nameEn": "4Life Immune Tea",
    "nameEs": "4Life Immune Tea",
    "category": "4Life Transfer Factor",
    "descriptionEn": "with PhytoFactor and Vitamin C\nPRIMARY SUPPORT: Immune System, Digestive Health, Daily Wellness*\nWorld’s only tea powered by plant-based Transfer Factor\n• Features PhytoFactor—bioactive immune peptides for rapid response immune support*^\n• Made with six organic botanicals: ginger, elderberry, rosehips, astragalus, hibiscus, lemon peel\n• Naturally caffeine-free herbal blend crafted to enjoy from sunrise to sunset\n• Delicious and soothing lemon-honey-ginger flavor profile\n• Contains throat-soothing ingredients\n• 35 mg Vitamin C per serving\n• Naturally sweetened with stevia\n• Great for ages 6 and older [able to drink hot beverages safely]",
    "descriptionEs": "PhytoFactor y Vitamina C\nRESPALDO PRINCIPAL: Sistema inmunológico, Salud digestiva,\nBienestar general *\nEl único té inmunológico reforzado con factores de transferencia de origen vegetal\n• Incluye PhytoFactor—péptidos inmunológicos bioactivos de origen vegetal para una rápida respuesta inmunológica. *^\n• Elaborado con seis ingredientes botánicos—jengibre, baya de saúco, escaramujo, astrágalo, flor de jamaica y cáscara de limón.\n• Mezcla herbal naturalmente libre de cafeína, diseñada para disfrutarse en el día y en la noche.\n• Delicioso y reconfortante sabor a limón, miel y jengibre.\n• Contiene ingredientes reconfortantes para la garganta.\n• Aporta 35 mg de vitamina C por porción.\n• Endulzado de forma natural con estevia.\n• Ideal para tomar a partir de los 6 años.",
    "ingredientsEn": "Proprietary Blend (ginger (Zingiber officinale) root, elderberry (Sambucus nigra) fruit, rosehips (Rosae canina fructus) fruit, hibiscus (Hibiscus sabdariffa) flower, astragalus (Astragalus membranaceus) root, lemon (Citrus limonum) peel), honey flavor, PhytoFactor, lemon flavor, vitamin C, and stevia extract",
    "ingredientsEs": "Proprietary Blend (ginger (Zingiber officinale) root, elderberry (Sambucus nigra) fruit, rosehips (Rosae canina fructus) fruit, hibiscus (Hibiscus sabdariffa) flower, astragalus (Astragalus membranaceus) root, lemon (Citrus limonum) peel), honey flavor, PhytoFactor, lemon flavor, vitamin C, and stevia extract",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 Tea Bags",
    "sizeEs": "15 bolsitas de té",
    "presentations": [
      {
        "item": "13033",
        "retail": 21.0,
        "discount": 18.0,
        "wholesale": 17.0,
        "lp": 10,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Immune Tea"
    ],
    "isPack": false,
    "sourcePage": 24
  },
  {
    "id": "Super Greens",
    "nameEn": "Super Greens",
    "nameEs": "Super Greens",
    "category": "4Life Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Core Nutrition, Cellular Health, Digestive Health,\nImmune System*\nCore plant-based nutrition and immune support that is keto and paleo friendly *\n• The only greens drink that contains 300 mg of PhytoFactor plant-based bioactive immune peptides for rapid response immune support *^\n• Offers a vegan Transfer Factor supplement option\n• Provides ultra-dense whole food nutrition from time tested superfood ingredients *\n• Contains prebiotic fiber to promote digestive health and regularity, and support a healthy gut microbiome *\n• Great for ages 6 and up",
    "descriptionEs": "RESPALDO PRINCIPAL: Nutrición básica, Salud celular, Salud digestiva,\nSistema inmunológico *\nNutrición esencial a base de plantas y respaldo inmunológico apto para dietas keto y paleo *\n• La única bebida verde que contiene 300 mg de los péptidos inmunológicos bioactivos de origen vegetal PhytoFactor para un respaldo inmunológico de respuesta rápida. *^\n• Es una opción vegana de suplementación con factores de transferencia. *\n• Proporciona nutrición integral ultraconcentrada a base de superalimentos de eficacia comprobada. *\n• Contiene fibra prebiótica para promover la salud y regularidad digestiva, y respaldar la salud de la microbiota intestinal. *\n• Ideal para consumirse a partir de los 6 años.",
    "ingredientsEn": "Super Phytonutrient Blend (Tapioca (Manihot esculenta) tuber, pumpkin (Curcurbita pepo) seeds, spinach (Spinacea oleracea) leaves, sweet potato (Ipomoea batatas) root, chlorella (Chlorella spp.) algae, spirulina (Arthrospira",
    "ingredientsEs": "Super Phytonutrient Blend (Tapioca (Manihot esculenta) tuber, pumpkin (Curcurbita pepo) seeds, spinach (Spinacea oleracea) leaves, sweet potato (Ipomoea batatas) root, chlorella (Chlorella spp.) algae, spirulina (Arthrospira platensis) algae, carrot (Daucus carota) root, alfalfa (Medicago sativa) sprouts, bell pepper (Capsicum",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 Stick Packs",
    "sizeEs": "15 sobres individuales",
    "presentations": [
      {
        "item": "24146",
        "retail": 58.0,
        "discount": 48.0,
        "wholesale": 46.0,
        "lp": 32,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Super Greens"
    ],
    "isPack": false,
    "sourcePage": 25
  },
  {
    "id": "4Life Transfer Factor RioVida Superfruit Immune Shot",
    "nameEn": "4Life Transfer Factor RioVida Superfruit Immune Shot",
    "nameEs": "4Life Transfer Factor RioVida Shot Inmunológico de Superfrutas",
    "category": "RioVida",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Healthy Aging, Antioxidant, Overall Wellness * SECONDARY SUPPORT: Brain Health, Heart Health, Energy *\nThe immune goodness of RioVida in a single immune shot *\n• Contains 4Life Transfer Factor bioactive immune peptides, which are clinically proven to activate the immune system within two hours *1\n• Supports the immune system’s natural ability to recognize, respond to, and remember potential health threats with 600 mg of 4Life Transfer Factor *\n• Includes a proprietary combination of antioxidant and natural fruit juices, including açaí, pomegranate, aronia berry, maqui, blueberry, and elderberry *\n• Delivers essential antioxidants that fight against free radicals *\n• Contains vitamin C to provide immune support, antioxidant power, and essential support for healthy bones, teeth, blood vessels, and collagen synthesis *\n• For ages 2 and up",
    "descriptionEs": "RESPALDO PRIMARIO: Sistema inmunológico. Envejecimiento saludable, Antioxidante, Bienestar General * RESPALDO SECUNDARIO: Salud del cerebro. Salud cardiovascular. Energía *\nPotente respaldo inmunológico y antioxidante en un delicioso shot líquido. *\n• Contiene los péptidos bioactivos 4Life Transfer Factor para respaldar la capacidad natural del sistema inmunológico de reconocer posibles amenazas a la salud, responder ante ellas y recordarlas. *\n• Contiene la Dosis Diaria de 600 mg de 4Life Transfer Factor que ha demostrado clínicamente activar el sistema inmunológico en el transcurso de dos horas. *1\n• Incluye una mezcla exclusiva de jugos de frutas naturales ricas en antioxidantes y bioflavonoides, como el açaí, la granada, la baya de aronia, la baya de maqui, el arándano azul y la baya de saúco. *\n• .Aporta antioxidantes esenciales para combatir los radicales libres. *\n• Contiene vitamina C para fortalecer el sistema inmunológico, aportar refuerzo antioxidante y contribuir a la salud de los huesos, los dientes y los vasos sanguíneos, así como a la síntesis de colágeno * .\n• Puede tomarse a partir de los dos años.",
    "ingredientsEn": "4Life Transfer Factor Peptide Blend (UltraFactor, OvoFactor, and NanoFactor) RioVida Juice Blend (apple, purple grape, blueberry, açaí, pomegranate, and elderberry juices from concentrate), filtered water, glycerin, berry and other natural flavors, grape juice concentrate, and potassium sorbate.",
    "ingredientsEs": "4Life Transfer Factor Peptide Blend (UltraFactor, OvoFactor, and NanoFactor) RioVida Juice Blend (apple, purple grape, blueberry, açaí, pomegranate, and elderberry juices from concentrate), filtered water, glycerin, berry and other natural flavors, grape juice concentrate, and potassium sorbate.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "18 oz bottle",
    "sizeEs": "Botella de 18 fl oz",
    "presentations": [
      {
        "item": "24141",
        "retail": 53.0,
        "discount": 45.0,
        "wholesale": 42.0,
        "lp": 32,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor RioVida Superfruit Immune Shot",
      "4Life Transfer Factor RioVida Shot Inmunológico de Superfrutas",
      "RioVida Superfruit Immune Shot"
    ],
    "isPack": false,
    "sourcePage": 28
  },
  {
    "id": "4Life Transfer Factor RioVida Stix",
    "nameEn": "4Life Transfer Factor RioVida Stix",
    "nameEs": "4Life Transfer Factor RioVida Stix Tri-Factor Formula",
    "category": "RioVida",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Healthy Aging, Antioxidant, Overall Wellness * SECONDARY SUPPORT: Brain Health, Heart Health, Energy *\nThe immune system goodness of RioVida in a portable powder packet *\n• Supports the immune system with 600 mg of 4Life Transfer Factor bioactive immune peptides per serving *\n• Contains 4Life Transfer Factor, which is clinically proven to activate the immune system within two hours *1\n• Delivers essential antioxidants from açaí, pomegranate, and blueberry *\n• Portable and easy to share\n• Contains no artificial sweeteners, flavors, or preservatives\n• Features electrolytes, which help keep your body running and keep you hydrated *",
    "descriptionEs": "RESPALDO PRIMARIO: Sistema inmunológico. Envejecimiento saludable. Antioxidante. Bienestar general. * RESPALDO SECUNDARIO: Salud del cerebro. Salud cardiovascular. Energía *\nLas bondades inmunitarias de RioVida en sobres individuales con una mezcla en polvo. *\n• .Respalda el sistema inmunológico con 600 mg de los péptidos inmunológicos bioactivos 4Life Transfer Factor por porción. *\n• Contiene 4Life Transfer Factor, que ha demostrado clínicamente activar el sistema inmunológico en el transcurso de dos horas. *1\n• Ofrece antioxidantes esenciales provenientes del açaí, la granada y el arándano azul. *\n• Es fácil de llevar y compartir.\n• Puede tomarse a partir de los dos años.\n• Sin saborizantes, edulcorantes, ni conservantes artificiales.\n• Contiene electrolitos que ayudan a mantener el funcionamiento del cuerpo y la hidratación. *",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor) and RioVida Proprietary Blend (açaí, blueberry, elderberry fruit powder, grapeseed extract, and pomegranate hull extract).",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor) and RioVida Proprietary Blend (açaí, blueberry, elderberry fruit powder, grapeseed extract, and pomegranate hull extract).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 powder packets",
    "sizeEs": "15 sobres individuales",
    "presentations": [
      {
        "item": "24113",
        "retail": 40.0,
        "discount": 34.0,
        "wholesale": 32.0,
        "lp": 20,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor RioVida Stix",
      "4Life Transfer Factor RioVida Stix Tri-Factor Formula",
      "RioVida Stix"
    ],
    "isPack": false,
    "sourcePage": 28
  },
  {
    "id": "4Life Transfer Factor RioVida Burst",
    "nameEn": "4Life Transfer Factor RioVida Burst",
    "nameEs": "4Life Transfer Factor RioVida Burst Tri-Factor Formula",
    "category": "RioVida",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Healthy Aging, Antioxidant, Overall Wellness * SECONDARY SUPPORT: Brain Health, Heart Health, Energy *\nThe immune system goodness of RioVida, conveniently packaged in a smooth and delicious edible gel blend *\n• Contains certified 4Life Transfer Factor and a proprietary combination of antioxidant-rich natural fruits, including açaí, pomegranate, blueberry, and elderberry *\n• Contains 600 mg of 4Life Transfer Factor bioactive immune peptides, which are, which is clinically proven to activate the immune system within two hours *1\n• Is portable and easy to share\n• Includes UltraFactor, OvoFactor, and NanoFactor—Tri-Factor Formula\n• Is for ages two and up",
    "descriptionEs": "RESPALDO PRIMARIO: Sistema inmunológico. Envejecimiento saludable. Antioxidante. Bienestar general. * RESPALDO SECUNDARIO: Salud del cerebro. Salud cardiovascular. Energía. *\nLas bondades que ofrece RioVida para el sistema inmunológico en un conveniente paquete con un gel suave y delicioso. *\n• Contiene una mezcla exclusiva de frutas ricas en antioxidantes, incluyendo el açaí, la granada, el arándano azul y la baya del saúco. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor, que han demostrado clínicamente activar el sistema inmunológico en el transcurso de dos horas. *1\n• Contiene la fórmula 4Life Tri-Factor—UltraFactor, OvoFactor y NanoFactor.\n• Es fácil de llevar y compartir y puede consumirse a partir de los dos años.",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor) and RioVida Juice Blend (apple, purple grape, blueberry, açaí, pomegranate, and elderberry juices from concentrate).",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor) and RioVida Juice Blend (apple, purple grape, blueberry, açaí, pomegranate, and elderberry juices from concentrate).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 gel packs",
    "sizeEs": "",
    "presentations": [
      {
        "item": "24110",
        "retail": 49.0,
        "discount": 42.0,
        "wholesale": 39.0,
        "lp": 27,
        "labelEn": "",
        "labelEs": null
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor RioVida Burst",
      "4Life Transfer Factor RioVida Burst Tri-Factor Formula",
      "RioVida Burst"
    ],
    "isPack": false,
    "sourcePage": 29
  },
  {
    "id": "4Life Transfer Factor RioVida Chews",
    "nameEn": "4Life Transfer Factor RioVida Chews",
    "nameEs": "4Life Transfer Factor RioVida Chews Tri-Factor Formula",
    "category": "RioVida",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Healthy Aging, Antioxidant, Overall Wellness * SECONDARY SUPPORT: Brain Health, Heart Health, Energy *\nThe immune system support of RioVida in a delicious, convenient chew *\n• Provides immune system and antioxidant benefits *\n• Features a delicious berry flavor\n• Comes in convenient, individually wrapped chews for ages four and up\n• Includes vitamin C for an extra immune system boost *\n• Contains 600 mg of 4Life Transfer Factor bioactive immune peptides, which are clinically proven to activate the immune system within two hours *^1\n• Helps Raise Your Immune I.Q. ® with 4Life Transfer Factor *",
    "descriptionEs": "RESPALDO PRIMARIO: Sistema inmunológico. Envejecimiento saludable. Antioxidante. Bienestar general. * RESPALDO SECUNDARIO: Salud del cerebro. Salud cardiovascular. Energía. *\nEl respaldo para el sistema inmunológico de RioVida, en un delicioso cubito masticable. *\n• Ofrece beneficios para el sistema inmunológico y antioxidantes. *\n• Tiene un delicioso sabor a frutos rojos.\n• Clínicamente comprobado que activa el sistema inmunológico en el transcurso de dos horas. *^1\n• Prácticos cubitos masticables envueltos individualmente que pueden consumirse a partir de los cuatro años.\n• Incluye vitamina C para un impulso adicional al sistema inmunológico. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para aumentar el cociente intelectual del sistema inmunológico. *",
    "ingredientsEn": "Vitamin C, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), and RioVida Juice Blend (apple, purple grape, blueberry, açaí, pomegranate, and elderberry juices from concentrate).",
    "ingredientsEs": "Vitamin C, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), and RioVida Juice Blend (apple, purple grape, blueberry, açaí, pomegranate, and elderberry juices from concentrate).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 chews",
    "sizeEs": "",
    "presentations": [
      {
        "item": "24118",
        "retail": 34.0,
        "discount": 29.0,
        "wholesale": 27.0,
        "lp": 21,
        "labelEn": "",
        "labelEs": null
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor RioVida Chews",
      "4Life Transfer Factor RioVida Chews Tri-Factor Formula",
      "RioVida Chews"
    ],
    "isPack": false,
    "sourcePage": 29
  },
  {
    "id": "4Life Transfer Factor Cardio",
    "nameEn": "4Life Transfer Factor Cardio",
    "nameEs": "4Life Transfer Factor Cardio",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Cardiovascular Health, Immune System * SECONDARY SUPPORT: Antioxidant *\nOffers cardio-protective benefits by reducing oxidative stress and modulating inflammation response *^\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Features certified 4Life Transfer Factor to educate immune cells and strengthen the heart’s first line of defense: the immune system *\n• Supports heart health, cardiovascular function, and circulatory function *\n• Provides a cellular defense against a low-quality diet and stressful lifestyle *\n• Promotes antioxidant levels *",
    "descriptionEs": "RESPALDO PRIMARIO: Salud cardiovascular. Sistema inmunológico. * RESPALDO SECUNDARIO: Antioxidante. *\nEn un estudio preclínico demostró ofrecer beneficios de protección cardíaca al reducir el estrés oxidativo y mejorar la respuesta inmunológica. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar a las células inmunológicas y fortalecer el sistema inmunológico que es la primera línea de defensa del corazón. *\n• Respalda la salud del corazón, el funcionamiento cardiovascular y la función circulatoria. *\n• Proporciona defensa celular frente a una dieta de mala calidad y un estilo de vida estresante. *\n• Promueve los niveles de antioxidantes. *",
    "ingredientsEn": "Microcrystalline cellulose, garlic bulb extract, magnesium oxide powder, coenzyme Q10, red rice yeast extract, colostrum filtrate, magnesium glycinate, selenomethionine, Ginkgo biloba leaf extract, OvoFactor, magnesium stearate, Polygonnum cospidatum root extract, silicon dioxide, vitamin B6 pyridoxine hydrochloride, NanoFactor, vitamin B12, and folic acid (vitamin B9). d-mannose, blueberry fruit, and lingonberry fruit), Kidney Support Blend (IP-6, Chanca piedra herb, juniper berry, dandelion leaf, and varuna stem bark extract), and pH Balancing Blend (apple cider vinegar, sodium bicarbonate, potassium bicarbonate, and calcium carbonate).",
    "ingredientsEs": "Microcrystalline cellulose, garlic bulb extract, magnesium oxide powder, coenzyme Q10, red rice yeast extract, colostrum filtrate, magnesium glycinate, selenomethionine, Ginkgo biloba leaf extract, OvoFactor, magnesium stearate, Polygonnum cospidatum root extract, silicon dioxide, vitamin B6 pyridoxine hydrochloride, NanoFactor, vitamin B12, and folic acid (vitamin B9).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "21010",
        "retail": 80.0,
        "discount": 68.0,
        "wholesale": 63.0,
        "lp": 52,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Cardio",
      "Cardio"
    ],
    "isPack": false,
    "sourcePage": 32
  },
  {
    "id": "4Life Transfer Factor ReCall",
    "nameEn": "4Life Transfer Factor ReCall",
    "nameEs": "4Life Transfer Factor ReCall",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Brain Health * SECONDARY SUPPORT: Immune System, Healthy Aging *\nTargeted brain support for optimal mental functioning *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Features certified 4Life Transfer Factor to educate immune system cells *\n• Promotes healthy brain function with blood circulation support *\n• Contains ingredients to support memory and brain health like Huperzia serrata, Bacopa monnieri, and Ginkgo biloba *",
    "descriptionEs": "RESPALDO PRIMARIO: Salud del cerebro. *\nRESPALDO SECUNDARIO: Sistema inmunológico. Envejecimiento saludable. *\nRespaldo específico para el cerebro para un funcionamiento mental óptimo. *\n• Incluye los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar a las células del sistema inmunológico. *\n• Promueve el funcionamiento saludable del cerebro al respaldar la circulación de la sangre. *\n• Contiene ingredientes para respaldar la memoria y la salud del cerebro, como Huperzia serrata , Bacopa Monieri y Ginkgo biloba . *",
    "ingredientsEn": "Magnesium, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), and Proprietary Blend [soy seed extracts, lemon balm herb extract, aerial parts (Bacopa monnieri) extract, n-acetyl-l-tyrosine, n-acetyl-l-cysteine, Ginkgo biloba leaf extract, and Huperzia serrata herb extract].",
    "ingredientsEs": "Magnesium, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), and Proprietary Blend [soy seed extracts, lemon balm herb extract, aerial parts (Bacopa monnieri) extract, n-acetyl-l-tyrosine, n-acetyl-l-cysteine, Ginkgo biloba leaf extract, and Huperzia serrata herb extract].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "22003",
        "retail": 70.0,
        "discount": 60.0,
        "wholesale": 55.0,
        "lp": 42,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor ReCall",
      "ReCall"
    ],
    "isPack": false,
    "sourcePage": 32
  },
  {
    "id": "4Life Transfer Factor GluCoach",
    "nameEn": "4Life Transfer Factor GluCoach",
    "nameEs": "4Life Transfer Factor GluCoach",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Glucose Metabolism * SECONDARY SUPPORT: Immune System, Antioxidant *\nSupports glucose levels and metabolism *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Includes certified 4Life Transfer Factor to educate immune system cells *\n• Includes minerals, herbs, and phytonutrients to support healthy glucose levels and promote pancreatic health *\n• Supports the endocrine system *",
    "descriptionEs": "RESPALDO PRIMARIO: Metabolismo de la glucosa. *\nRESPALDO SECUNDARIO: Sistema inmunológico. Antioxidante. *\nRespalda los niveles saludables de glucosa y el metabolismo. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar a las células del sistema inmunológico. *\n• Incluye minerales, hierbas y fitonutrientes para respaldar los niveles saludables de glucosa y promover la salud del páncreas. *\n• Respalda el sistema endocrino. *",
    "ingredientsEn": "Chromium, 4Life Transfer Factor Blend (UltraFactor and OvoFactor), vanadium, alpha lipoic acid, and Proprietary Blend (Pterocarpus marsupium heart wood extract, gymnema leaf extract, fenugreek seed extract, Momordica charantia fruit extract, and Korean ginseng root extract).",
    "ingredientsEs": "Chromium, 4Life Transfer Factor Blend (UltraFactor and OvoFactor), vanadium, alpha lipoic acid, and Proprietary Blend (Pterocarpus marsupium heart wood extract, gymnema leaf extract, fenugreek seed extract, Momordica charantia fruit extract, and Korean ginseng root extract).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "120 vegetable capsules",
    "sizeEs": "120 cápsulas vegetales",
    "presentations": [
      {
        "item": "29001",
        "retail": 80.0,
        "discount": 68.0,
        "wholesale": 63.0,
        "lp": 53,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor GluCoach",
      "GluCoach"
    ],
    "isPack": false,
    "sourcePage": 33
  },
  {
    "id": "4Life Transfer Factor AgePro",
    "nameEn": "4Life Transfer Factor AgePro",
    "nameEs": "4Life Transfer Factor AgePro",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Healthy Aging, Antioxidant * SECONDARY SUPPORT: Overall Wellness, Immune System *\nReprogram the way you age with this proprietary formula *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Supports healthy cellular aging *\n• Increases NAD+ levels in the blood *\n• Provides antioxidant support *\n• Supports a healthy immune system *\n• Is scientifically proven to extend lifespan and improve healthspan *^\n• Rejuvenates aging immune cells for a younger-acting immune system *\n• Improves endurance performance *\n• Targets the main pathways of biological aging *",
    "descriptionEs": "RESPALDO PRIMARIO: Envejecimiento saludable. Antioxidante. *\nRESPALDO SECUNDARIO: Bienestar general. Sistema inmunológico. *\nReprograma la forma en que envejeces con esta fórmula exclusiva. *\n• Respalda el envejecimiento celular saludable. *\n• Incrementa los niveles de NAD+ en la sangre. *\n• Se ha demostrado científicamente que puede mejorar la duración de la salud a lo largo de la vida y extender la esperanza de vida. * ^\n• Proporciona respaldo antioxidante. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para optimizar el funcionamiento del sistema inmunológico. *\n• Rejuvenece las células inmunológicas que están en proceso de envejecimiento para que el sistema inmunológico actúe de forma más juvenil. *\n• Mejora la resistencia y el desempeño físico. *\n• Se enfoca en los principales desafíos del envejecimiento biológico. *",
    "ingredientsEn": "Nicotinamide mononucleotide, apigenin, quercetin dihydrate, white button mushroom powdered extract, alpha- ketoglutaric acid, colostrum filtrate, NanoFactor, OvoFactor, and magnesium stearate.",
    "ingredientsEs": "Nicotinamide mononucleotide, apigenin, quercetin dihydrate, white button mushroom powdered extract, alpha-",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "28148",
        "retail": 75.0,
        "discount": 64.0,
        "wholesale": 59.0,
        "lp": 45,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor AgePro",
      "AgePro"
    ],
    "isPack": false,
    "sourcePage": 33
  },
  {
    "id": "4Life Transfer Factor Collagen",
    "nameEn": "4Life Transfer Factor Collagen",
    "nameEs": "4Life Transfer Factor Colágeno (fresa y mango)",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Healthy Aging, Skin Health & Beauty, Muscle & Joint Health * SECONDARY SUPPORT: Immune System, Antioxidant *\nFormula that features five types of collagen peptides; 4Life Transfer Factor Tri-Factor Formula; vitamins A, C, and E; biotin; and our Age-Defying Collagen Complex *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Provides total-body, healthy aging support with a refreshing strawberry-mango flavor *\n• Helps replenish collagen levels to support healthy joints, muscles, and skin *\n• Supports immune system function with 4Life Transfer Factor *\n• Improves skin moisture and elasticity *",
    "descriptionEs": "RESPALDO PRIMARIO: Envejecimiento saludable. Salud y belleza de la piel. Salud de los músculos y articulaciones. * RESPALDO SECUNDARIO: Sistema inmunológico. Antioxidante. *\nFórmula que contiene cinco tipos de péptidos de colágeno, la fórmula Tri-Factor, vitaminas A, C y E, biotina y nuestro complejo vegetal con propiedades rejuvenecedoras .*\n• Proporciona respaldo para el envejecimiento saludable de todo el cuerpo con un refrescante sabor a fresa y mango. *\n• Ayuda a reponer los niveles de colágeno para respaldar la salud de las articulaciones, los músculos y la piel. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para optimizar el funcionamiento del sistema inmunológico. *\n• Mejora la humectación y la elasticidad de la piel. *",
    "ingredientsEn": "Vitamin A (as vitamin A acetate), vitamin C (as absorbic acid), vitamin E (as d-alpha-tocopherol acetate), biotin, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Age-Defying Collagen Complex [hydrolyzed fish collagen (source of type I collagen), chicken bone broth collagen (source of type I, II, and III collagen), and eggshell membrane collagen (source of type I, V, and X collagen)], Age-Defying Plant Complex [wheat (Triticum aesitvum) seed extract and astaxanthin microalgae extract (Haematococcus pluvialis)], cane sugar, natural flavor, maltodextrin, malic acid, citric acid, salt, reb A, and sodium acetate.",
    "ingredientsEs": "Vitamin A (as vitamin A acetate), vitamin C (as absorbic acid), vitamin E (as d-alpha-tocopherol acetate), biotin, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Age-Defying Collagen Complex [hydrolyzed fish collagen (source of type I collagen), chicken bone broth collagen (source of type I, II, and III collagen), and eggshell membrane collagen (source of type I, V, and X collagen)], Age-Defying Plant Complex [wheat (Triticum aesitvum) seed extract and astaxanthin microalgae extract (Haematococcus pluvialis)], cane sugar, natural flavor, maltodextrin, malic acid, citric acid,",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 powder packets",
    "sizeEs": "15 sobres",
    "presentations": [
      {
        "item": "25404",
        "retail": 51.0,
        "discount": 43.0,
        "wholesale": 40.0,
        "lp": 28,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Collagen",
      "4Life Transfer Factor Collagen (strawberry-mango)",
      "4Life Transfer Factor Colágeno (fresa y mango)",
      "Collagen"
    ],
    "isPack": false,
    "sourcePage": 34
  },
  {
    "id": "4Life Transfer Factor Collagen Type I",
    "nameEn": "4Life Transfer Factor Collagen Type I",
    "nameEs": "4Life Transfer Factor Colágeno Tipo I (sin sabor)",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Healthy Aging, Skin Health & Beauty, Muscle Health * SECONDARY SUPPORT: Immune System, Antioxidant *\nNon-flavored formula that features type l collagen peptides to support skin, nails, hair, antioxidant levels, and the immune system *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Supports skin elasticity, moisture levels, skin tone, and skin repair *\n• Helps replenish collagen levels to support healthy nails and hair *\n• Supports immune system function with 4Life Transfer Factor *\n• Provides antioxidant support *\n• Supports joints and muscles *",
    "descriptionEs": "RESPALDO PRIMARIO: Envejecimiento saludable. Salud y belleza de la piel. Salud de los músculos. * RESPALDO SECUNDARIO: Sistema inmunológico. Antioxidante. *\nFórmula sin sabor que contiene péptidos de colágeno Tipo I para respaldar la piel, las uñas, los niveles de antioxidantes y el sistema inmunológico. *\n• Respalda la elasticidad, los niveles de humectación, el tono y la reparación de la piel. *\n• Ayuda a reponer los niveles de colágeno para respaldar las uñas y el cabello saludables. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para optimizar el funcionamiento del sistema inmunológico. *\n• Brinda respaldo antioxidante. *\n• Ofrece respaldo para los músculos y las articulaciones. *",
    "ingredientsEn": "Hydrolyzed collagen (fish), 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), vitamin E (d-alpha-tocopherol acetate), vitamin C (ascorbic acid 99%), sucrose, salt (sodium chloride), natural vanilla peppermint flavor, and maltodextrin.",
    "ingredientsEs": "Hydrolyzed collagen (fish), 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), vitamin E (d-alpha- tocopherol acetate), vitamin C (ascorbic acid 99%), sucrose, salt (sodium chloride), natural vanilla peppermint flavor, and maltodextrin.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 powder packets",
    "sizeEs": "15 sobres",
    "presentations": [
      {
        "item": "25417",
        "retail": 51.0,
        "discount": 43.0,
        "wholesale": 40.0,
        "lp": 28,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Collagen Type I",
      "4Life Transfer Factor Collagen Type l (flavorless)",
      "4Life Transfer Factor Colágeno Tipo I (sin sabor)",
      "Collagen Type I"
    ],
    "isPack": false,
    "sourcePage": 34
  },
  {
    "id": "4Life NanoFactor Glutamine Prime",
    "nameEn": "4Life NanoFactor Glutamine Prime",
    "nameEs": "4Life NanoFactor Glutamine Prime",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Overall Wellness * SECONDARY SUPPORT: Energy, Antioxidant, Digestive Health *\nEnergy source that helps fuel immune system cell activity and provides the building blocks of glutathione: an important antioxidant *\n• Supplies fuel to immune system cells with the important amino acid glutamine *\n• Features NanoFactor bioactive immune peptides to educate immune system cells *\n• Provides synergistic immune system support when taken with other 4Life Transfer Factor products *",
    "descriptionEs": "RESPALDO PRIMARIO: Sistema inmunológico. Bienestar general. * RESPALDO SECUNDARIO: Energía. Antioxidante. Salud digestiva. *\nFuente de energía que ayuda a estimular la actividad de las células del sistema inmunológico y proporciona los componentes del glutatión, un importante antioxidante. *\n• Aporta energía a las células del sistema inmunológico con glutamina, un importante aminoácido. *\n• Contiene NanoFactor—péptidos inmunológicos bioactivos para educar a las células del sistema inmunológico. *\n• Proporciona respaldo sinérgico para el sistema inmunológico cuando se toma con otros productos 4Life Transfer Factor. *",
    "ingredientsEn": "L-glutamine and Immune Energy Blend (l-arginine, n-acetyl-l-cysteine, alpha lipoic acid, l-alanyl-l- glutamine, and NanoFactor).",
    "ingredientsEs": "L-glutamine and Immune Energy Blend (l-arginine, n-acetyl-l-cysteine, alpha lipoic acid, l-alanyl-l- glutamine, and NanoFactor).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "120 vegetable capsules",
    "sizeEs": "120 cápsulas vegetales",
    "presentations": [
      {
        "item": "24087",
        "retail": 44.0,
        "discount": 37.0,
        "wholesale": 35.0,
        "lp": 27,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life NanoFactor Glutamine Prime"
    ],
    "isPack": false,
    "sourcePage": 35
  },
  {
    "id": "4Life Transfer Factor Metabolite",
    "nameEn": "4Life Transfer Factor Metabolite",
    "nameEs": "4Life Transfer Factor Metabolite",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Thyroid Metabolism, Immune System * SECONDARY SUPPORT: Post-Meal Metabolism, Weight Management *\nTargeted support for healthy thyroid hormone metabolism and antioxidant levels *\n• Features 4Life Transfer Factor bioactive peptides to support the immune system *\n• Supports healthy thyroid function *\n• Moderates thyroid hormone production *\n• Reduces post-meal oxidative stress *\n• Provides antioxidants *",
    "descriptionEs": "RESPALDO PRIMARIO: Función tiroidea en el metabolismo. Sistema inmunológico. * RESPALDO SECUNDARIO: Metabolismo después de las comidas. Control de peso. *\nRespaldo específico para el metabolismo saludable en el que interviene la tiroides y para los niveles de antioxidantes. *\n• Respalda el funcionamiento saludable de la tiroides. *\n• Modera la producción de las hormonas tiroideas. *\n• Reduce el estrés oxidativo posterior a las comidas. *\n• Proporciona antioxidantes. *\n• Contiene los péptidos inmunológicos 4Life Transfer Factor para respaldar el sistema inmunológico. *",
    "ingredientsEn": "Post-Meal Metabolism Blend [grape (Vitis vinifera) fruit and seed extracts, aronia (Aronia melanocarpa) fruit extract, pomegranate (Punica granatum) fruit extract, olive (Olea europaea) leaf extract, grapefruit (Citrus paradisi) fruit extract, and cranberry (Vaccinium macrocarpon) fruit extract], 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), iodine [from kelp (Laminaria digitata)], Proprietary Metabolic Blend (hydroxycinnamic acid and quercetin), and selenium (as selenomethionine).",
    "ingredientsEs": "Post-Meal Metabolism Blend [grape (Vitis vinifera) fruit and seed extracts, aronia (Aronia melanocarpa) fruit extract, pomegranate (Punica granatum) fruit extract, olive (Olea europaea) leaf extract, grapefruit (Citrus paradisi) fruit extract, and cranberry (Vaccinium macrocarpon) fruit extract], 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), iodine [from kelp (Laminaria digitata)], Proprietary Metabolic",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "26001",
        "retail": 46.0,
        "discount": 39.0,
        "wholesale": 36.0,
        "lp": 28,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Metabolite",
      "Metabolite"
    ],
    "isPack": false,
    "sourcePage": 35
  },
  {
    "id": "4Life Transfer Factor KBU",
    "nameEn": "4Life Transfer Factor KBU",
    "nameEs": "4Life Transfer Factor KBU",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Urinary Health * SECONDARY SUPPORT: Immune System, Antioxidant, Cleansing & Detox *\nA targeted formula for both men and women to support the urinary tract, kidneys, and bladder *\n• Features certified 4Life Transfer Factor bioactive immune peptides to educate immune system cells *\n• Supports the bladder with cleansing ingredients like dandelion, chanca piedra, varuna, and mannose *\n• Supports healthy kidney and urinary tract function with cranberry, IP-6, dandelion, chanca piedra, and varuna *",
    "descriptionEs": "RESPALDO PRIMARIO: Salud del tracto urinario. * RESPALDO SECUNDARIO: Sistema inmunológico. Antioxidante. Limpieza y desintoxicación. *\nUna fórmula para hombres y mujeres que ofrece respaldo específico para el tracto urinario, los riñones y la vejiga. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar a las células del sistema inmunológico. *\n• Incluye ingredientes como los arándanos rojos y azules, la hoja de diente de león y la baya de enebro para respaldar el funcionamiento del aparato urinario. *\n• Respalda el proceso de filtración saludable de los riñones con arándanos rojos, IP-6, chanca piedra y Crataeva nurvala . *",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Bladder Support Blend (cranberry fruit powder and extract,",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Bladder Support Blend (cranberry fruit powder and extract, d-mannose, blueberry fruit, and lingonberry fruit), Kidney Support Blend (IP-6, Chanca piedra herb, juniper berry, dandelion leaf, and varuna stem bark extract), and pH Balancing Blend (apple cider vinegar, sodium bicarbonate, potassium bicarbonate, and calcium carbonate).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "120 vegetable capsules",
    "sizeEs": "120 cápsulas vegetales",
    "presentations": [
      {
        "item": "25501",
        "retail": 67.0,
        "discount": 57.0,
        "wholesale": 53.0,
        "lp": 42,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor KBU",
      "KBU"
    ],
    "isPack": false,
    "sourcePage": 36
  },
  {
    "id": "4Life Transfer Factor Lung",
    "nameEn": "4Life Transfer Factor Lung",
    "nameEs": "4Life Transfer Factor Lung",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Respiratory System * SECONDARY SUPPORT: Immune System *\nTargeted support for the lungs and overall respiratory function *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Promotes proper respiratory function *\n• Supports healthy lung tissue *\n• Helps the body detox from air pollution damage *\n• Supports your airway’s natural defenses against pollution-based damage *\n• Educates, enhances, and balances the immune system with our exclusive Tri-Factor Formula *",
    "descriptionEs": "RESPALDO PRIMARIO: Sistema respiratorio. * RESPALDO SECUNDARIO: Sistema inmunológico. *\nRespaldo específico para los pulmones y la función respiratoria en general. *\n• Promueve una función respiratoria adecuada. *\n• Respalda el tejido pulmonar saludable. *\n• Ayuda al cuerpo a desintoxicarse de la contaminación del aire. *\n• Respalda las defensas naturales de las vías respiratorias ante el daño causado por la contaminación. *\n• Contiene la mezcla de péptidos bioactivos 4Life Transfer Factor—UltraFactor, OvoFactor y NanoFactor—para educar, mejorar y equilibrar el sistema inmunológico. *",
    "ingredientsEn": "Vitamin A (as beta carotene), vitamin C, vitamin E (as d-alpha-tocopherol), 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), and Lung Detox Blend [thyme (Thymus vulgaris) leaf/flower extract, Korean ginseng (Panax ginseng) root extract, broccoli (Brassica oleracea) seed extract, n-acetyl-l-cysteine, black cumin (Nigella sativa) seed extract, citrus (Citrus spp.) fruit/peel extract, bilberry (Vaccinium myrtillus) fruit extract, and mustard (Brassica hirta) seed extract].",
    "ingredientsEs": "Vitamin A (as beta carotene), vitamin C, vitamin E (as d-alpha-tocopherol), 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), and Lung Detox Blend [thyme (Thymus vulgaris) leaf/flower extract, Korean ginseng (Panax ginseng) root extract, broccoli (Brassica oleracea) seed extract, n-acetyl-l-cysteine, black cumin (Nigella sativa) seed extract, citrus (Citrus spp.) fruit/peel extract, bilberry (Vaccinium myrtillus) fruit extract, and mustard (Brassica hirta) seed extract].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "21501",
        "retail": 57.0,
        "discount": 48.0,
        "wholesale": 45.0,
        "lp": 33,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Lung",
      "Lung"
    ],
    "isPack": false,
    "sourcePage": 36
  },
  {
    "id": "4Life Transfer Factor Belle Vie",
    "nameEn": "4Life Transfer Factor Belle Vie",
    "nameEs": "4Life Transfer Factor Belle Vie",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Female Health * SECONDARY SUPPORT: Immune System, Antioxidant *\nTargeted support for female reproductive and breast health *\n• Features certified 4Life Transfer Factor bioactive immune peptides to educate immune system cells *\n• Includes a blend of herbal antioxidants, phytoestrogens, indoles, and calcium d-glucarate to support female endocrine health *\n• Promotes overall feminine reproductive health *",
    "descriptionEs": "RESPALDO PRIMARIO: Salud de la mujer. * RESPALDO SECUNDARIO: Sistema inmunológico. Antioxidante. *\nRespaldo específico para la salud reproductiva femenina y los senos. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar a las células del sistema inmunológico. *\n• Incluye una mezcla de antioxidantes herbarios, fitoestrógenos, indoles y D-glucarato de calcio para respaldar la salud del sistema endocrino femenino. *\n• Promueve la salud reproductiva femenina general. *",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Antioxidant Proprietary Blend (green tea leaf extract and grapeseed extract), Phytoestrogen Proprietary Blend (flaxseed extract, kudzu root extract, and red clover plant extract), and Cruciferous Proprietary Blend (broccoli, cabbage, kale–containing indole-3- carbinol, diindoyl methane, ascorbigen, and calcium d-glucarate).",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor),",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "22535",
        "retail": 66.0,
        "discount": 56.0,
        "wholesale": 52.0,
        "lp": 43,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Belle Vie",
      "Belle Vie"
    ],
    "isPack": false,
    "sourcePage": 37
  },
  {
    "id": "4Life Transfer Factor MalePro",
    "nameEn": "4Life Transfer Factor MalePro",
    "nameEs": "4Life Transfer Factor MalePro",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Male Health * SECONDARY SUPPORT: Immune System, Antioxidant *\nTargeted support for optimal prostate health *\n• Features certified 4Life Transfer Factor bioactive immune peptides to educate immune system cells *\n• Includes saw palmetto, lycopene, isoflavones, broccoli extract, and antioxidants to support prostate health *",
    "descriptionEs": "RESPALDO PRIMARIO: Salud del hombre. * RESPALDO SECUNDARIO: Sistema inmunológico. Antioxidante. *\nRespaldo específico para la salud óptima de la próstata. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar a las células del sistema inmunológico. *\n• Incluye palma enana americana, licopeno, isoflavonas, extracto de brócoli y antioxidantes para respaldar la salud de la próstata. *",
    "ingredientsEn": "Zinc, selenium, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), saw palmetto fruit extract, lycopene, and Proprietary Blend (nettle root extract, kudzu root extract, soy bean extract, broccoli whole plant extract, and calcium d-glucarate).",
    "ingredientsEs": "Zinc, selenium, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), saw palmetto fruit extract, lycopene, and Proprietary Blend (nettle root extract, kudzu root extract, soy bean extract, broccoli whole plant extract, and calcium d-glucarate).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 softgels",
    "sizeEs": "90 cápsulas blandas",
    "presentations": [
      {
        "item": "22562",
        "retail": 76.0,
        "discount": 65.0,
        "wholesale": 60.0,
        "lp": 44,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor MalePro",
      "MalePro"
    ],
    "isPack": false,
    "sourcePage": 37
  },
  {
    "id": "4Life Transfer Factor Reflexion",
    "nameEn": "4Life Transfer Factor Reflexion",
    "nameEs": "4Life Transfer Factor Reflexion",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Sleep, Mood, & Stress; Brain Health * SECONDARY SUPPORT: Immune System *\nPromotes relaxation, improved mood, and the ability to focus during occasional stress *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Enhances your ability to cope with the daily stresses of life *\n• Promotes relaxation, a positive mood, and the ability to focus *\n• Supports the immune system’s ability to function properly in times of occasional stress *\n• Improves cognitive function *",
    "descriptionEs": "RESPALDO PRIMARIO: Sueño, estado de ánimo y estrés. Salud del cerebro. * RESPALDO SECUNDARIO: Sistema inmunológico. *\nPromueve un mejor estado de ánimo y la habilidad de enfocarse en momentos de estrés ocasional. *\n• Incluye los péptidos inmunológicos bioactivos 4Life Transfer Factor para respaldar la capacidad del sistema inmunológico para funcionar adecuadamente en los momentos de estrés ocasional. *\n• Mejora la capacidad para manejar el estrés ocasional de la vida diaria. *\n• Promueve la relajación, el estado de ánimo positivo y la capacidad para concentrarse. *\n• Mejora el funcionamiento cognitivo. *",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor) and Proprietary Blend [wild green oat (Avena sativa) extract and l-theanine].",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor) and Proprietary Blend [wild green oat (Avena sativa) extract and l-theanine].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "22005",
        "retail": 66.0,
        "discount": 56.0,
        "wholesale": 52.0,
        "lp": 40,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Reflexion",
      "Reflexion"
    ],
    "isPack": false,
    "sourcePage": 38
  },
  {
    "id": "4Life Transfer Factor SleepRite",
    "nameEn": "4Life Transfer Factor SleepRite",
    "nameEs": "4Life Transfer Factor SleepRite",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "PRIMARY SUPPORT: Sleep, Relaxation * SECONDARY SUPPORT: Immune System *\nCalms the mind and body, promotes better sleep, and supports the immune system *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Helps you fall asleep more quickly and improves sleep quality *\n• Supports body and mind balance *\n• Educates the immune system *\n• Is clinically researched",
    "descriptionEs": "RESPALDO PRIMARIO: Sueño. Relajación. * RESPALDO SECUNDARIO: Sistema inmunológico. *\nCalma la mente y el cuerpo, promueve un mejor sueño y respalda el sistema inmunológico. *\n• Incluye los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar al sistema inmunológico. *\n• Ayuda a conciliar el sueño más rápidamente y mejora la calidad del sueño. *\n• Respalda el equilibrio de la mente y el cuerpo. *\n• Ha sido investigado clínicamente.",
    "ingredientsEn": "GABA (γ-aminobutyric acid), 4Life Transfer Factor Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Relax Blend [ashwagandha (Withania somnifera) root extract, gum, chia seed protein, sea salt, wheatgrass (Triticum aestivum) young leaves, blue spirulina, stevia, immune peptides from whey, and hibiscus extract. lavandin (Lavandula hybrida) oil, and lavender (Lavandula angustifolia) oil], magnesium (as magnesium oxide and biglycinate), vitamin B6 (as pyridoxal 5’-phosphate), melatonin (sustained-release), gelatin capsule, palm oil, hydroxypropyl, methylcellulose, and sunflower lecithin.",
    "ingredientsEs": "GABA (γ-aminobutyric acid), 4Life Transfer Factor Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Relax Blend [ashwagandha (Withania somnifera) root extract, lavandin (Lavandula hybrida) oil, and lavender (Lavandula angustifolia) oil], magnesium (as magnesium oxide and biglycinate), vitamin B6 (as pyridoxal 5’-phosphate), melatonin (sustained-release), gelatin capsule, palm oil, hydroxypropyl, methylcellulose, and sunflower lecithin.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "28133",
        "retail": 42.0,
        "discount": 36.0,
        "wholesale": 33.0,
        "lp": 25,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor SleepRite",
      "SleepRite"
    ],
    "isPack": false,
    "sourcePage": 38
  },
  {
    "id": "4Life Transfer Factor Vista",
    "nameEn": "4Life Transfer Factor Vista",
    "nameEs": "4Life Transfer Factor Vista",
    "category": "Targeted Transfer Factor",
    "descriptionEn": "• Vision is our most dominant sense. • Over 1 billion people worldwide live with some form of vision impairment.\nPRIMARY SUPPORT: Eye Health * SECONDARY SUPPORT: Immune System, Antioxidant *\nTargeted support for optimal vision performance and eye health *\n• Features 4LIfe Transfer Factor bioactive immune peptides to educate immune system cells *\n• Helps maintain visual acuity and sharpness *\n• Includes ingredients to help reduce the oxidative effects of the sun and excessive blue light exposure on the macula of the eyes *\n• Promotes healthy eye function *\n• Supports the eyes’ ability to adapt to varying light conditions *",
    "descriptionEs": "• La visión es el sentido más predominante. • Más de mil millones de personas en todo el mundo tienen algún tipo de deficiencia visual.\n¿Por qué es importante cuidar la salud de los ojos?\nRESPALDO PRIMARIO: Salud ocular. * RESPALDO SECUNDARIO: Sistema inmunológico. Antioxidante. *\nRespaldo específico para una visión óptima y la salud de los ojos. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar a las células del sistema inmunológico. *\n• Ayuda a mantener la agudeza visual. *\n• Incluye ingredientes que ayudan a reducir los efectos oxidativos del sol y la exposición excesiva a la luz azul en la mácula ocular. *\n• Promueve el funcionamiento saludable de los ojos. *\n• Respalda la capacidad de los ojos para adaptarse a las condiciones variables de iluminación. *",
    "ingredientsEn": "Vitamin A, vitamin C, vitamin E, zinc, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), lutein, zeaxanthin, and Ocular Health Proprietary Blend (Haematococcus pluvialis microalgae extract, bilberry fruit extract, Spirulina microalgae, citrus bioflavonoids peel extract, black currant fruit extract, Ginkgo biloba leaf extract, blackberry fruit extract, and ascorbigen).",
    "ingredientsEs": "Vitamin A, vitamin C, vitamin E, zinc, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), lutein, zeaxanthin, and Ocular Health Proprietary Blend (Haematococcus pluvialis microalgae extract, bilberry fruit extract, Spirulina microalgae, citrus bioflavonoids peel extract, black currant fruit extract, Ginkgo biloba leaf extract, blackberry fruit extract, and ascorbigen).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "29501",
        "retail": 66.0,
        "discount": 56.0,
        "wholesale": 52.0,
        "lp": 40,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Vista",
      "Vista"
    ],
    "isPack": false,
    "sourcePage": 39
  },
  {
    "id": "RiteStart Women",
    "nameEn": "RiteStart Women",
    "nameEs": "RiteStart Mujer",
    "category": "RiteStart",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Healthy Aging, Antioxidant, Heart Health, Female Health, Multivitamin & Mineral, Muscle & Bone Health, Overall Wellness * SECONDARY SUPPORT: Brain Health, Energy, Eye Health, Skin Health & Beauty *\nTwice-daily supplement packets for women\nTake RiteStart Women every day for:\n• Immune system support from 4Life Transfer Factor Plus Tri-Factor Formula *\n• A unique blend of antioxidants *\n• Cardiovascular and circulatory support *",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Envejecimiento saludable. Antioxidante. Salud cardiovascular. Salud de la mujer. Multivitaminas y minerales. Salud de los músculos y huesos. Bienestar general. * RESPALDO SECUNDARIO: Salud del cerebro. Energía. Salud ocular. Salud y belleza de la piel. *\nPaquetes de suplementos para mujeres para tomar dos veces al día.\nTOMAR RITESTART MUJER A DIARIO PROPORCIONA:\n• Respaldo para el sistema inmunológico con 4Life Transfer Factor Plus Tri-Factor Formula. *\n• Respaldo específico para el sistema femenino. *\n• Una mezcla única de antioxidantes. *\n• Respaldo para los sistemas cardiovascular y circulatorio. *\n• Respaldo para un equilibrio hormonal saludable. *",
    "ingredientsEn": "Vitamin C, vitamin D, vitamin E, vitamin K2, thiamin, riboflavin, niacin, vitamin B6, vitamin B12, biotin, pantothenic acid, calcium, iron, iodine, magnesium, zinc, selenium, copper, manganese, chromium, molybdenum, boron, vanadium, 4Life Transfer Factor Plus Tri-Factor Formula, Essential Fatty Acid Complex, Proprietary OPC Blend (grapeseed extract and pinebark extract), Proprietary Antioxidant Blend (rutin, marigold petals extract, green tea leaf extract, alpha lipoic acid, coenzyme Q10, and bilberry fruit extract), and Proprietary Support Blend (glucosamine hydrochloride, calcium d-glucarate, n-acetyl-l-cysteine, hydrolyzed collagen powder, and Ginkgo biloba leaf extract).\nWomen’s Health Blend (ipriflavone, turmeric, soya bean seed extract, broccoli sprout extract, and diindolylmethane).",
    "ingredientsEs": "Vitamin C, vitamin D, vitamin E, vitamin K2, thiamin, riboflavin, niacin, vitamin B6, vitamin B12, biotin, pantothenic acid, calcium, iron, iodine, magnesium, zinc, selenium, copper, manganese, chromium, molybdenum, boron, vanadium, 4Life Transfer Factor Plus Tri-Factor Formula, Essential Fatty Acid Complex, Proprietary OPC Blend (grapeseed extract and pinebark extract), Proprietary Antioxidant Blend (rutin, marigold petals extract, green tea leaf extract, alpha lipoic acid, coenzyme Q10, and bilberry fruit extract), and Proprietary Support Blend (glucosamine hydrochloride, calcium d-glucarate, n-acetyl-l-cysteine, hydrolyzed collagen powder, and Ginkgo biloba leaf extract).\nWomen’s Health Blend (ipriflavone, turmeric, soya bean seed extract, broccoli sprout extract, and diindolylmethane).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 packet carton",
    "sizeEs": "Caja de 30 paquetitos",
    "presentations": [
      {
        "item": "27019",
        "retail": 99.0,
        "discount": 84.0,
        "wholesale": 79.0,
        "lp": 59,
        "labelEn": "1 carton",
        "labelEs": "1 Caja"
      },
      {
        "item": "27020",
        "retail": 198.0,
        "discount": 168.0,
        "wholesale": 156.0,
        "lp": 118,
        "labelEn": "2 carton pack",
        "labelEs": "2 Cajas"
      },
      {
        "item": "26541",
        "retail": 198.0,
        "discount": 168.0,
        "wholesale": 156.0,
        "lp": 118,
        "labelEn": "1 Women, 1 Men",
        "labelEs": "1 Hombre + 1 Mujer"
      }
    ],
    "image": null,
    "aliases": [
      "RiteStart Women",
      "RiteStart Mujer"
    ],
    "isPack": false,
    "sourcePage": 42
  },
  {
    "id": "RiteStart Men",
    "nameEn": "RiteStart Men",
    "nameEs": "RiteStart Hombre",
    "category": "RiteStart",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Healthy Aging, Antioxidant, Heart Health, Male Health, Multivitamin & Mineral, Muscle & Bone Health, Overall Wellness * SECONDARY SUPPORT: Brain Health, Energy, Eye Health, Skin Health *\nTwice-daily supplement packets for men\nTake RiteStart Men every day for:\n• Immune system support from 4Life Transfer Factor Plus Tri-Factor Formula *\n• Skin health support *\n• A unique blend of antioxidants *\n• Cardiovascular and circulatory support *",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Envejecimiento saludable. Antioxidante. Salud cardiovascular. Salud del hombre. Multivitaminas y minerales. Salud de los músculos y huesos. Bienestar general. * RESPALDO SECUNDARIO: Salud del cerebro. Energía. Salud ocular. Salud y belleza de la piel. *\nPaquetes de suplementos para hombres para tomar dos veces al día.\nTOMAR RITESTART HOMBRE A DIARIO PROPORCIONA:\n• Respaldo para el sistema inmunológico con 4Life Transfer Factor Plus Tri- Factor Formula. *\n• Respaldo específico para el sistema masculino. *\n• Una mezcla única de antioxidantes. *\n• Respaldo para los sistemas cardiovascular y circulatorio. *",
    "ingredientsEn": "Vitamin C, vitamin D, vitamin E, vitamin K2, thiamin, riboflavin, niacin, vitamin B6, vitamin B12, biotin, pantothenic acid, calcium, iron, iodine, magnesium, zinc, selenium, copper, manganese, chromium, molybdenum, boron, vanadium, 4Life Transfer Factor Plus Tri-Factor Formula, Essential Fatty Acid Complex, Proprietary OPC Blend (grapeseed extract and pinebark extract), Proprietary Antioxidant Blend (rutin, marigold petals extract, green tea leaf extract, alpha lipoic acid, coenzyme Q10, and bilberry fruit extract), and Proprietary Support Blend (glucosamine hydrochloride, calcium d-glucarate, n-acetyl-l-cysteine, hydrolyzed collagen powder, and Ginkgo biloba leaf extract).\nMen’s Health Blend (turmeric root extract, broccoli sprout extract, tomato fruit extract, soya bean seed extract, and diindolylmethane).",
    "ingredientsEs": "Vitamin C, vitamin D, vitamin E, vitamin K2, thiamin, riboflavin, niacin, vitamin B6, vitamin B12, biotin, pantothenic acid, calcium, iron, iodine, magnesium, zinc, selenium, copper, manganese, chromium, molybdenum, boron, vanadium, 4Life Transfer Factor Plus Tri-Factor Formula, Essential Fatty Acid Complex, Proprietary OPC Blend (grapeseed extract and pinebark extract), Proprietary Antioxidant Blend (rutin, marigold petals extract, green tea leaf extract, alpha lipoic acid, coenzyme Q10, and bilberry fruit extract), and Proprietary Support Blend (glucosamine hydrochloride, calcium d-glucarate, n-acetyl-l-cysteine, hydrolyzed collagen powder, and Ginkgo biloba leaf extract).\nMen’s Health Blend (turmeric root extract, broccoli sprout extract, tomato fruit extract, soya bean seed extract, and diindolylmethane).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 packet carton",
    "sizeEs": "• Respaldo para la visión y los ojos. * Caja de 30 paquetitos",
    "presentations": [
      {
        "item": "26538",
        "retail": 99.0,
        "discount": 84.0,
        "wholesale": 79.0,
        "lp": 59,
        "labelEn": "1 carton",
        "labelEs": "1 Caja"
      },
      {
        "item": "26539",
        "retail": 198.0,
        "discount": 168.0,
        "wholesale": 156.0,
        "lp": 118,
        "labelEn": "2 carton pack",
        "labelEs": "2 Cajas"
      },
      {
        "item": "26541",
        "retail": 198.0,
        "discount": 168.0,
        "wholesale": 156.0,
        "lp": 118,
        "labelEn": "1 Women, 1 Men",
        "labelEs": "1 Hombre + 1 Mujer"
      }
    ],
    "image": null,
    "aliases": [
      "RiteStart Men",
      "RiteStart Hombre"
    ],
    "isPack": false,
    "sourcePage": 43
  },
  {
    "id": "RiteStart Kids & Teens",
    "nameEn": "RiteStart Kids & Teens",
    "nameEs": "RiteStart Niños y Adolescentes",
    "category": "RiteStart",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Multivitamin & Mineral, Overall Wellness * SECONDARY SUPPORT: Energy; Muscle, Bone, & Joint Health; Skin Health *\nGreat for kids and teens ages 2–18\nTake RiteStart Kids & Teens every day for:\nSuggested serving is two (2) or four (4) chewable tablets daily, depending on age.\n• 300 to 600 mg of 4Life Transfer Factor Tri-Factor Formula\n• Immune system support to help your body recognize, respond to, and remember potential health threats *\n• 22 essential vitamins and minerals for growing bodies *\n• Support for strong bones *\n• B vitamins and the essential nutrient choline for healthy brain function *\n• Healthy vision, muscle function, and skin support *\n• Antioxidant support *\n• Vitamins A, C, and E\n• Assorted citrus cream and sour apple flavors",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Multivitaminas y minerales. Bienestar general. * RESPALDO SECUNDARIO: Energía. Salud de los músculos, los huesos, las articulaciones y la piel. *\nPerfecto para niños y adolescentes entre 2 y 18 años.\nTOMAR RITESTART NIÑOS Y ADOLESCENTES A DIARIO PORPORCIONA:\nDosis diaria recomendada: dos (2) o cuatro (4) tabletas según la edad.\n• De 300 a 600 mg de la fórmula 4Life Tri-Factor.\n• Respaldo para el sistema inmunológico para ayudar al cuerpo a reconocer posibles amenazas a la salud, responder ante ellas y recordarlas. *\n• 22 vitaminas y minerales esenciales para los cuerpos en crecimiento. *\n• Respaldo para huesos fuertes. *\n• Vitaminas B y colina (un ingrediente esencial) para el funcionamiento saludable del cerebro. *\n• Respaldo para la salud ocular, la función muscular y la piel. *\n• Respaldo antioxidante. *\n• Vitamins A, C y E.\n• Tabletas masticables sabor cítrico cremoso y manzana agria.",
    "ingredientsEn": "Vitamin C, vitamin D, vitamin E, vitamin K, thiamin, riboflavin, niacin (as niacinamide), vitamin B6, folate, vitamin B12, biotin, pantothenic acid, calcium, iron, iodine, magnesium, zinc, selenium, copper, manganese, chromium, and 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor).",
    "ingredientsEs": "Vitamin C, vitamin D, vitamin E, vitamin K, thiamin, riboflavin, niacin (as niacinamide), vitamin B6, folate, vitamin B12, biotin, pantothenic acid, calcium, iron, iodine, magnesium, zinc, selenium, copper, manganese, chromium, and 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "120 tablets",
    "sizeEs": "120 tabletas",
    "presentations": [
      {
        "item": "24126",
        "retail": 62.0,
        "discount": 53.0,
        "wholesale": 49.0,
        "lp": 35,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "RiteStart Kids & Teens",
      "RiteStart Niños y Adolescentes"
    ],
    "isPack": false,
    "sourcePage": 44
  },
  {
    "id": "NutraStart Blue Vanilla",
    "nameEn": "NutraStart Blue Vanilla",
    "nameEs": "NutraStart Blue Vanilla",
    "category": "RiteStart",
    "descriptionEn": "PRIMARY SUPPORT: General Nutrition, Vitamin & Mineral * SECONDARY SUPPORT: Weight Management, Immune System *\nSupport weight management and optimized macro and micronutrient nutrition with NutraStart Blue Vanilla *\n• Supports a healthy immune system response with 4Life Transfer Factor bioactive immune peptides *\n• Provides potent antioxidant support *\n• A good source of fiber *\n• Supports satiety and may reduce feelings of hunger *\n• Supports healthy teeth and bones *\n• Promotes energy production *\n• Supports cardiovascular health *\n• Supports eye health *",
    "descriptionEs": "RESPALDO PRINCIPAL: Nutrición general. Vitaminas y minerales. * RESPALDO SECUNDARIO: Control de peso. Sistema inmunológico. *\nRespaldo para el control de peso y una nutrición optimizada con macronutrientes y micronutrientes. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para optimizar la respuesta del sistema inmunológico. *\n• Proporciona un potente respaldo antioxidante. *\n• Es una buena fuente de fibra. *\n• Respalda la saciedad y puede reducir la sensación de hambre. *\n• Respalda la salud dental y ósea. *\n• Promueve la producción de energía. *\n• Respalda la salud cardiovascular. *\n• Respalda la salud de los ojos. *",
    "ingredientsEn": "Calcium (as dicalcium phosphate), sodium, magnesium (as magnesium oxide), potassium, 4Life Transfer Factor Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), vitamin C (as ascorbic acid), protein, iron (as ferric citrate), niacin (as niacinamide), vitamin E (as d-alpha tocopheryl acetate), zinc (zinc oxide), pantothenic acid (as d-calcium pantothenate), vitamin B6 (as pyridoxine HCL), riboflavin, thiamin (as thiamine mononitrate), copper (as copper gluconate), vitamin A (as vitamin A palmitate), folate (as 82 mcg folic acid), iodine (as potassium iodide), biotin, vitamin D (as cholecalciferol), vitamin B12 (as cyanocobalamin), whey protein concentrate, sunflower oil powder (sunflower oil, maltodextrin, sodium caseinate, mono- and diglycerides, tocopherols, and tricalcium phosphate), modified food starch, soluble corn fiber, organic cane sugar, natural flavors, honey powder, apple fiber, hydrolyzed guar gum, oat fiber, xanthan",
    "ingredientsEs": "Calcium (as dicalcium phosphate), sodium, magnesium (as magnesium oxide), potassium, 4Life Transfer Factor Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), vitamin C (as ascorbic acid), protein, iron (as ferric citrate), niacin (as niacinamide), vitamin E (as d-alpha tocopheryl acetate), zinc (zinc oxide), pantothenic acid (as d-calcium pantothenate), vitamin B6 (as pyridoxine HCL), riboflavin, thiamin (as thiamine mononitrate), copper (as copper gluconate), vitamin A (as vitamin A palmitate), folate (as 82 mcg folic acid), iodine (as potassium iodide), biotin, vitamin D (as cholecalciferol), vitamin B12 (as cyanocobalamin), whey protein concentrate, sunflower oil powder (sunflower oil, maltodextrin, sodium caseinate, mono- and diglycerides, tocopherols, and tricalcium phosphate), modified food starch, soluble corn fiber, organic cane sugar, natural flavors, honey powder, apple fiber, hydrolyzed guar gum, oat fiber, xanthan gum, chia seed protein, sea salt, wheatgrass (Triticum aestivum) young leaves, blue spirulina, stevia, immune peptides from whey, and hibiscus extract.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15-serving (19.5 oz) canister",
    "sizeEs": "Bote de 15 porciones (19.5 oz)",
    "presentations": [
      {
        "item": "28130",
        "retail": 70.0,
        "discount": 60.0,
        "wholesale": 55.0,
        "lp": 30,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "NutraStart Blue Vanilla"
    ],
    "isPack": false,
    "sourcePage": 44
  },
  {
    "id": "Digest4Life Reset System",
    "nameEn": "Digest4Life Reset System",
    "nameEs": "Sistema de Restauración Digest4Life",
    "category": "Digest4Life",
    "descriptionEn": "PRIMARY SUPPORT: Digestive Health * SECONDARY SUPPORT: Immune System *\n• Cleans and purifies a clogged gastrointestinal tract *\n• Nourishes liver function, supporting its role in the digestive process *\n• Soothes and supports the gastrointestinal tract *\n• Optimizes healthy gut bacteria growth with our exclusive microbeadlet delivery *\n• Increases the amount and longevity of beneficial gut flora by up to 1,000 times over standard delivery *\n• Supports healthy immune system function and digestive health with 4Life Transfer Factor bioactive immune peptides *\n1—4Life Transfer Factor Tri-Factor Formula\n2—Pre/o Biotics\n1—Fibre System Plus\n1—Super Detox\n1—Digestive Enzymes\n1—Aloe Vera Stix\n1—Digest4Life Reset System Guidebook\nUse the Digest4Life Reset System twice\na year to cleanse, detox, and replenish\nyour digestive system! *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud digestiva. * RESPALDO SECUNDARIO: Sistema inmunológico. *\n• Limpia y purifica el tracto gastrointestinal obstruido. *\n• Sustenta el funcionamiento del hígado, respaldando su función en el proceso digestivo. *\n• Alivia y respalda el tracto gastrointestinal. *\n• Optimiza el crecimiento de las bacterias intestinales beneficiosas con nuestro exclusivo método de administración a través de microesferas. *\n• Aumenta la cantidad y longevidad de la microbiota intestinal hasta 1,000 veces más que una administración estándar. *\n• Respalda el funcionamiento saludable del sistema inmunológico y la salud digestiva con el poder de los péptidos inmunológicos bioactivos 4Life Transfer Factor. *\n1—4Life Transfer Factor Tri-Factor Formula\n2—Pre/o Biotics\n1—Fibre System Plus\n1—Super Detox\n1—Digestive Enzymes\n1—Aloe Vera Stix\n1—Guía del Sistema de Restauración Digest4Life Usar el Sistema de Restauración Digest4Life dos veces al año ayuda a limpiar, desintoxicar\ny restablecer el sistema digestivo. *",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "Digest4Life Reset System",
    "sizeEs": "Sistema de Restauración Digest4Life",
    "presentations": [
      {
        "item": "53996",
        "retail": 343.0,
        "discount": 292.0,
        "wholesale": 250.0,
        "lp": 174,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Digest4Life Reset System",
      "Sistema de Restauración Digest4Life"
    ],
    "isPack": true,
    "sourcePage": 48
  },
  {
    "id": "Pre/o Biotics",
    "nameEn": "Pre/o Biotics",
    "nameEs": "Pre/o Biotics",
    "category": "Digest4Life",
    "descriptionEn": "PRIMARY SUPPORT: Digestive Health, Immune System *\nThe only prebiotic/probiotic product in the world with 4Life Transfer Factor bioactive immune peptides *\n• Optimizes healthy gut bacteria growth with our exclusive microbeadlet delivery *\n• Increases the amount and longevity of beneficial gut flora by up to 1,000 times over standard delivery *\n• Supports healthy immune system function *\n• Requires no refrigeration\n4Life Transfer Factor Tri-Factor Formula\nAn independent university study assessed the potential benefit of 4Life Transfer Factor Tri-Factor Formula in Pre/o Biotics. This in vitro study measured probiotic growth in the presence or absence of 4Life Transfer Factor Tri-Factor Formula in comparison to common prebiotics. Results revealed that 4Life Transfer Factor Tri-Factor Formula enhances Pre/o Biotics by stimulating probiotic growth. These data suggest that 4Life Transfer Factor Tri-Factor Formula has prebiotic effects and enhances the benefits of the other ingredients in Pre/o Biotics. * Hoffman, D., Oberg, C., & Domek, M. (2018). Rapid method for measuring the effect of prebiotics on probiotic bacterial growth. Weber State University, UT. American Dairy Science Association, Knoxville, TN (conference abstract #M123). https://m.adsa.org/2018/abs/t/74631",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud digestiva. Sistema inmunológico. *\nEl único producto de prebióticos/probióticos en el mundo que contiene los péptidos inmunológicos 4Life Transfer Factor. *\n• Optimiza el crecimiento de las bacterias intestinales beneficiosas con nuestro exclusivo método de administración a través de microesferas. *\n• Aumenta la cantidad y longevidad de la microbiota intestinal hasta 1,000 veces más que una administración estándar. *\n• Respalda el funcionamiento saludable del sistema inmunológico. *\n• No requiere refrigeración.\n4Life Transfer Factor Tri-Factor Formula\nEn un estudio universitario independiente se evaluaron los posibles beneficios de 4Life Transfer Factor Tri-Factor Formula en Pre/o Biotics. En este estudio in vitro se midió el crecimiento de los probióticos en presencia o ausencia de 4Life Transfer Factor Tri-Factor Formula en comparación con los probióticos comunes. Los resultados mostraron que 4Life Transfer Factor Tri-Factor Formula mejora la función de Pre/o Biotics al estimular el crecimiento de los probióticos. Esta información sugiere que 4Life Transfer Factor Tri-Factor Formula tiene efectos prebióticos y mejora los beneficios de los demás ingredientes en Pre/o Biotics. *1\n\n1 Hoffman, D.; Oberg, C.; y Domek, M. (2018). Método rápido para medir el efecto de los prebióticos en el crecimiento de los probióticos. Weber State University, Utah. American Dairy Science Association, Knoxville, Tennessee (reseña de conferencia No. M123, en inglés). https://m.adsa.org/2018/abs/t/74631",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Probiotics [Bifidobacterium longum (BB536), Bifidobacterium lactis (Bl-04), Bifidobacterium infantis (M-63), Lactobacillus rhamnosus (Lr-32), and Lactobacillus acidophilus (NCFM)], and Prebiotic Blend [Galactooligosaccharides (GOS), Xylooligosaccharides (XOS), and Fructooligosaccharide (FOS)].",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), Probiotics [Bifidobacterium longum (BB536), Bifidobacterium lactis (Bl-04), Bifidobacterium infantis (M-63), Lactobacillus rhamnosus (Lr-32), and Lactobacillus acidophilus (NCFM)], and Prebiotic Blend [Galactooligosaccharides (GOS), Xylooligosaccharides (XOS), and Fructooligosaccharide (FOS)].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 stick packs",
    "sizeEs": "15 sobres individuales",
    "presentations": [
      {
        "item": "23020",
        "retail": 59.0,
        "discount": 50.0,
        "wholesale": 47.0,
        "lp": 35,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Pre/o Biotics"
    ],
    "isPack": false,
    "sourcePage": 49
  },
  {
    "id": "Aloe Vera Stix",
    "nameEn": "Aloe Vera Stix",
    "nameEs": "Aloe Vera Stix",
    "category": "Digest4Life",
    "descriptionEn": "PRIMARY SUPPORT: Digestive Health * SECONDARY SUPPORT: Immune System, Overall Wellness *\nAloe vera in powder packets for digestive health support *\n• Aids recovery from intestinal cleanses and detox diets *\n• Promotes healthy gastrointestinal function *\n• Soothes the gastrointestinal tract *\n• Promotes healthy immune system function *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud digestiva. * RESPALDO SECUNDARIO: Sistema inmunológico. Bienestar general. *\nAloe vera en polvo para respaldar la salud digestiva. *\n• Asiste en la recuperación de las limpiezas intestinales y las dietas desintoxicantes. *\n• Promueve el funcionamiento gastrointestinal saludable. *\n• Alivia el tracto gastrointestinal. *\n• Promueve el funcionamiento saludable del sistema inmunológico. *",
    "ingredientsEn": "Aloe vera gel concentrate, ascorbic acid, ethanol, erythoribic acid, sodium benzoate, potassium sorbate, and monoglycerides.",
    "ingredientsEs": "Aloe vera gel concentrate, ascorbic acid, ethanol, erythoribic acid, sodium benzoate, potassium sorbate, and monoglycerides.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 powder packets",
    "sizeEs": "15 sobres individuales",
    "presentations": [
      {
        "item": "23033",
        "retail": 36.0,
        "discount": 31.0,
        "wholesale": 30.0,
        "lp": 22,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Aloe Vera Stix"
    ],
    "isPack": false,
    "sourcePage": 50
  },
  {
    "id": "Digestive Enzymes",
    "nameEn": "Digestive Enzymes",
    "nameEs": "Digestive Enzymes",
    "category": "Digest4Life",
    "descriptionEn": "PRIMARY SUPPORT: Cleansing & Detox, Digestive Health *\nComplete digestive enzyme solution for all your digestive health needs *\n• Supports healthy digestion of food *\n• Reduces intestinal discomfort associated with food consumption *\n• Supports overall digestive health *",
    "descriptionEs": "RESPALDO PRINCIPAL: Limpieza y desintoxicación. Salud digestiva. *\nUna fórmula completa de enzimas digestivas para todas tus necesidades digestivas. *\n• Respalda la digestión saludable de los alimentos. *\n• Reduce las molestias intestinales asociadas con la digestión. *\n• Respalda la salud digestiva general. *",
    "ingredientsEn": "Proprietary Enzyme Blend (amylase, protease 4.5, glucosamylase, acid maltase, α-galactosidase, pectinase, cellulase, peptidase, protease 3.0, bromelain, lipase, inverstase, hemicellulase, ß-glucanase, xylanase, and papain).",
    "ingredientsEs": "Proprietary Enzyme Blend (amylase, protease 4.5, glucosamylase, acid maltase, α-galactosidase, pectinase, cellulase, peptidase, protease 3.0, bromelain, lipase, inverstase, hemicellulase, ß-glucanase, xylanase, and papain).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "23017",
        "retail": 44.0,
        "discount": 37.0,
        "wholesale": 35.0,
        "lp": 25,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Digestive Enzymes"
    ],
    "isPack": false,
    "sourcePage": 50
  },
  {
    "id": "Fibre System Plus",
    "nameEn": "Fibre System Plus",
    "nameEs": "Fibre System Plus",
    "category": "Digest4Life",
    "descriptionEn": "PRIMARY SUPPORT: Cleansing & Detox, Digestive Health * SECONDARY SUPPORT: Weight Management *\nA 10-day gastrointestinal cleanse *\n• Contains more than 20 herbal ingredients to provide thorough, comfortable intestinal cleansing and purification *\n• Provides an excellent gastrointestinal cleanse to start any nutritional regimen *\n• Contains key ingredients such as cascara sagrada, frangula, prunes, pineapple, papain, and bromelain",
    "descriptionEs": "RESPALDO PRINCIPAL: Limpieza y desintoxicación. Salud digestiva. * RESPALDO SECUNDARIO: Control de peso. *\nUna limpieza gastrointestinal de diez días. *\n• Contiene más de 20 ingredientes herbarios para proporcionar una limpieza y purificación intestinal cómoda y completa. *\n• Ofrece una excelente limpieza gastrointestinal para empezar cualquier régimen nutricional. *\n• Contiene ingredientes clave, como cáscara sagrada, frángula, ciruela, piña, papaína y bromelina.",
    "ingredientsEn": "Fiber Blend (psyllium husk, rice seed bran, apple fruit fiber, slippery elm inner bark, prune fruit, marshmallow root, locust bean gum, and xanthan gum), Cleansing Blend (black walnut hull, cascara sagrada bark, gentian root, licorice root, and buckthorn bark), Nutrition Blend (cranberry fruit, pineapple fruit, papaya fruit, sage leaf, parsley leaf, Irish moss whole plant, bee pollen, and spirulina), and Herbal Blend (ginger root, hops flower, and chamomile flower).",
    "ingredientsEs": "Fiber Blend (psyllium husk, rice seed bran, apple fruit fiber, slippery elm inner bark, prune fruit, marshmallow root, locust bean gum, and xanthan gum), Cleansing Blend (black walnut hull, cascara sagrada bark, gentian root, licorice root, and buckthorn bark), Nutrition Blend (cranberry fruit, pineapple fruit, papaya fruit, sage leaf, parsley leaf, Irish moss whole plant, bee pollen, and spirulina), and Herbal Blend (ginger root, hops flower, and chamomile flower).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 packets",
    "sizeEs": "30 paquetitos",
    "presentations": [
      {
        "item": "28134",
        "retail": 46.0,
        "discount": 39.0,
        "wholesale": 37.0,
        "lp": 24,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Fibre System Plus"
    ],
    "isPack": false,
    "sourcePage": 51
  },
  {
    "id": "PhytoLax",
    "nameEn": "PhytoLax",
    "nameEs": "PhytoLax",
    "category": "Digest4Life",
    "descriptionEn": "PRIMARY SUPPORT: Cleansing & Detox * SECONDARY SUPPORT: Digestive Health *\nSupport for digestive health, cleansing, and detox *\n• Contains herbs such as cascara sagrada and ginger to safely activate digestive elimination *\n• Promotes healthy regularity *",
    "descriptionEs": "RESPALDO PRINCIPAL: Limpieza y desintoxicación. * RESPALDO SECUNDARIO: Salud digestiva. *\nRespaldo para la salud digestiva, la limpieza y la desintoxicación. *\n• Contiene hierbas como la cáscara sagrada y jengibre para activar la eliminación digestiva de manera segura. *\n• Promueve la regularidad saludable. *",
    "ingredientsEn": "Laxative Blend [Rhubarb (Rhuem palmatum) rhizome and root extract, ginger (Zingiber officinale) root, cascara sagrada (Rhamnus purshiana) bark extract, buckthorn (Rhamnus frangula) bark extract, black walnut (Juglans nigra) hull, and senna (Cassia senna) leaf extract] and vegetable capsule. extract, ALCAR, green tea leaf extract, ashwagandha root extract, turmeric rhizome extract, resveratrol, and black pepper fruit extract).",
    "ingredientsEs": "Laxative Blend [Rhubarb (Rhuem palmatum) rhizome and root extract, ginger (Zingiber officinale) root, cascara sagrada (Rhamnus purshiana) bark extract, buckthorn (Rhamnus frangula) bark extract, black walnut (Juglans nigra) hull, and senna (Cassia senna) leaf extract] and vegetable capsule.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 vegetable capsules",
    "sizeEs": "30 cápsulas vegetales",
    "presentations": [
      {
        "item": "28131",
        "retail": 28.0,
        "discount": 24.0,
        "wholesale": 22.0,
        "lp": 16,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "PhytoLax"
    ],
    "isPack": false,
    "sourcePage": 51
  },
  {
    "id": "Super Detox",
    "nameEn": "Super Detox",
    "nameEs": "Super Detox",
    "category": "Digest4Life",
    "descriptionEn": "PRIMARY SUPPORT: Cleansing & Detox, Digestive Health *\nSupports healthy liver function *\n• Includes milk thistle, which supports healthy liver function *\n• Contains red clover and artichoke to aid in detoxification and liver strength *\n• Provides antioxidant support through n-acetyl-l-cysteine *",
    "descriptionEs": "RESPALDO PRINCIPAL: Limpieza y desintoxicación. Salud digestiva. *\nRespaldo para el funcionamiento saludable del hígado. *\n• Incluye cardo lechoso, conocido por el respaldo que ofrece al funcionamiento saludable del hígado. *\n• Contiene trébol rojo y alcachofa para ayudar en la desintoxicación y fortalecimiento del hígado. *\n• Proporciona respaldo antioxidante con N-acetil cisteína. *",
    "ingredientsEn": "Detox Proprietary Blend (red clover flower tops, milk thistle fruit extract, calcium d-glucarate, broccoli stalks/florets extract, bupleurum root extract, n-acetyl-l-cysteine, and artichoke leaf).",
    "ingredientsEs": "Detox Proprietary Blend (red clover flower tops, milk thistle fruit extract, calcium d-glucarate, broccoli stalks/florets extract, buplerum root extract, n-acetyl-l-cysteine, and artichoke leaf).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "23015",
        "retail": 37.0,
        "discount": 31.0,
        "wholesale": 29.0,
        "lp": 21,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Super Detox"
    ],
    "isPack": false,
    "sourcePage": 52
  },
  {
    "id": "Tea4Life",
    "nameEn": "Tea4Life",
    "nameEs": "Tea4Life",
    "category": "Digest4Life",
    "descriptionEn": "PRIMARY SUPPORT: Cleansing & Detox, Digestive Health *\nNatural cleansing tea for intestinal maintenance and regularity *\n• Features senna leaf and other herbs to support colon health *\n• Provides an herbal alternative for healthy digestive cleansing *\n• Boasts a tasty apple-cinnamon flavor with no artificial colors, flavors, or sweeteners",
    "descriptionEs": "RESPALDO PRINCIPAL: Limpieza y desintoxicación. Salud digestiva. *\nTé natural para la limpieza, el mantenimiento y la regularidad intestinal. *\n• Contiene hoja de sena y otras hierbas para respaldar la función del colon. *\n• Ofrece una alternativa herbal para una limpieza digestiva saludable. *\n• Tiene un agradable sabor a manzana y canela sin colorantes, saborizantes, ni edulcorantes artificiales.",
    "ingredientsEn": "Proprietary Blend (senna leaf, stevia leaf, cinnamon bark, buckthorn bark, ginger root, orange peel, green tea leaf, echinacea aerial parts, rooibos branch and leaf, astragalus root, and bitter orange fruit).",
    "ingredientsEs": "Proprietary Blend (senna leaf, stevia leaf, cinnamon bark, buckthorn bark, ginger root, orange peel, green tea leaf, echinacea aerial parts, rooibos branch and leaf, astragalus root, and bitter orange fruit).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 tea bags",
    "sizeEs": "30 bolsitas de té",
    "presentations": [
      {
        "item": "13004",
        "retail": 27.5,
        "discount": 23.0,
        "wholesale": 22.0,
        "lp": 15,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Tea4Life"
    ],
    "isPack": false,
    "sourcePage": 52
  },
  {
    "id": "Pro-TF",
    "nameEn": "Pro-TF",
    "nameEs": "Pro-TF",
    "category": "4LifeTransform",
    "descriptionEn": "PRIMARY SUPPORT: Weight Management, Muscle & Sports Performance, Immune System * SECONDARY SUPPORT: Heart Health; Muscle, Bone, & Joint Health *\nProtein supplement to help you transform your body and live a more fulfilling and vibrant life *\n• Provides 20 g of patent-pending 4LifeTransform Protein Formula per 2-scoop serving and is one of the most advanced and effective proteins available to help you transform your body, optimize performance, and promote health *\n• Includes an essential protein source, extensively hydrolyzed (high DH) whey and egg protein, and 600 of 4Life Transfer Factor in every 2-scoop serving *\n• Offers an independently and university-tested formula to support calorie and fat burning, muscle protection and growth, increased metabolism, and hunger suppression *\n• Includes only 140 calories per 2-scoop serving, is gluten free, and contains less than 1 g of lactose\n• Contains 4Life Transfer Factor bioactive immune peptides, which are clinically proven to activate the immune system within two hours *1",
    "descriptionEs": "RESPALDO PRINCIPAL: Control de peso. Músculos y rendimiento deportivo. Sistema inmunológico. * RESPALDO SECUNDARIO: Salud cardiovascular. Salud de los músculos, huesos y articulaciones. *\nSuplemento proteínico que ayuda a transformar el cuerpo y vivir una vida más plena y vibrante. *\n• Proporciona 20 g de proteína por cada porción de 2 cucharadas medidoras de la fórmula proteínica con patente pendiente de la línea 4LifeTransform. *\n• Cada porción de 2 cucharadas medidoras incluye una fuente de proteína esencial, proteína de suero de leche y huevo, extensivamente hidrolizada (high-DH), y además, 600 mg de 4Life Transfer Factor. *\n• Es una fórmula analizada independientemente y a nivel universitario que contribuye a quemar calorías y grasas, proteger y generar masa muscular, aumentar el metabolismo y suprimir el apetito. *\n• Incluye solo 140 calorías en cada porción de 2 cucharadas medidoras, es libre de gluten y contiene menos de 1 g de lactosa. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor, que han demostrado clínicamente activar el sistema inmunológico en el transcurso de dos horas. *1",
    "ingredientsEn": "4LifeTransform Protein Formula Low Molecular Weight Pro-TF Protein Blend, extensively hydrolyzed whey protein concentrate, extensively hydrolyzed egg white protein, low-glycemic maltodextrin, cocoa powder, natural chocolate and vanilla cream flavors, medium chain triglyceride (MCT) oil powder, sucralose, acesulfame-potassium (Ace-K), and 4Life Tri-Factor Formula [UltraFactor (ultra-ﬁltered colostrum powder), OvoFactor (egg yolk powder), and NanoFactor (nano-ﬁltered colostrum powder)].",
    "ingredientsEs": "4LifeTransform Protein Formula Low Molecular Weight Pro-TF Protein Blend, extensively hydrolyzed whey protein concentrate, extensively hydrolyzed egg white protein, low- glycemic maltodextrin, cocoa powder, natural chocolate and vanilla cream flavors, medium chain triglyceride (MCT) oil powder, sucralose, acesulfame- potassium (Ace-K), and 4Life Tri-Factor Formula [UltraFactor (ultra-ﬁltered colostrum powder), Antioxidant Proprietary Blend (green tea leaf extract and grapeseed extract), Phytoestrogen Proprietary Blend (flaxseed extract, kudzu root extract, and red clover plant extract), and Cruciferous Proprietary Blend (broccoli, cabbage, kale–containing indole-3- carbinol, diindoyl methane, ascorbigen, and calcium d-glucarate).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "23-serving (897 g canister)",
    "sizeEs": "Bote de 23 porciones",
    "presentations": [
      {
        "item": "27568",
        "retail": 73.0,
        "discount": 62.0,
        "wholesale": 58.0,
        "lp": 26,
        "labelEn": "Vanilla Cream",
        "labelEs": "Vainilla"
      },
      {
        "item": "27577",
        "retail": 73.0,
        "discount": 62.0,
        "wholesale": 58.0,
        "lp": 26,
        "labelEn": "Chocolate",
        "labelEs": "Chocolate"
      }
    ],
    "image": null,
    "aliases": [
      "Pro-TF"
    ],
    "isPack": false,
    "sourcePage": 56
  },
  {
    "id": "4LifeTransform PreZoom",
    "nameEn": "4LifeTransform PreZoom",
    "nameEs": "4LifeTransform PreZoom",
    "category": "4LifeTransform",
    "descriptionEn": "PRIMARY SUPPORT: Exercise Performance, Muscle * SECONDARY SUPPORT: Immune System, Brain Health *\n“Zoom” through your workout and fine-tune your mind\nand body during exercise *\n• Features 4Life Transfer Factor bioactive immune peptides to educate and enhance your immune system *\n• Helps build lean muscle mass, strength, and endurance *\n• Improves focus while exercising *\n• Supports the immune system, which can be compromised by intense exercise *\n• Comes in an easy-to-mix, melon-flavored powder *",
    "descriptionEs": "RESPALDO PRINCIPAL: Desempeño al hacer ejercicio. Músculos. * RESPALDO SECUNDARIO: Sistema inmunológico. Salud del cerebro. *\nAyuda a arrasar con la rutina de ejercicios y a que la mente y el cuerpo se adapten durante las sesiones de entrenamiento. *\n• Ayuda a aumentar la masa muscular magra, la fuerza y la resistencia. *\n• Mejora el enfoque durante el ejercicio. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para respaldar el funcionamiento del sistema inmunológico, el cual puede verse afectado al hacer ejercicio intenso. *\n• Viene en una presentación en polvo con sabor a sandía que se mezcla fácilmente.",
    "ingredientsEn": "Carnosyn® (beta-Alanine), sodium bicarbonate, potassium bicarbonate, creatine, betaine HCL, BCAA 2:1:1, l-glutamine, l-citrulline,",
    "ingredientsEs": "Carnosyn® (beta-Alanine), sodium bicarbonate, potassium bicarbonate, creatine, betaine HCL, BCAA 2:1:1, l-glutamine, l-citrulline, l-tyrosine, green tea leaf extract, l-theanine, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), acesulfame potassium, summer red color, watermelon flavor, maltodextrin, and sucralose.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "20 servings (320 g canister)",
    "sizeEs": "Bote de 20 porciones (320 g)",
    "presentations": [
      {
        "item": "24204",
        "retail": 73.0,
        "discount": 62.0,
        "wholesale": 58.0,
        "lp": 38,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4LifeTransform PreZoom",
      "PreZoom"
    ],
    "isPack": false,
    "sourcePage": 57
  },
  {
    "id": "4Life Transfer Factor Renuvo",
    "nameEn": "4Life Transfer Factor Renuvo",
    "nameEs": "4Life Transfer Factor Renuvo",
    "category": "4LifeTransform",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Healthy Aging, Antioxidant, Overall Wellness *\nA patented adaptogenic formula that targets healthy aging by supporting a more youthful and healthy response to environmental threats *\n• Features 4Life Transfer Factor bioactive immune peptides *\n• Promotes total-body recovery *\n• Helps counteract the telltale signs of aging *\n• Supports healthy mental acuity *\n• Promotes healthy sexual vitality and energy *",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Envejecimiento saludable. Antioxidante. Bienestar general. *\nUn adaptógeno patentado que se enfoca en el envejecimiento saludable al respaldar una respuesta más juvenil y saludable ante las amenazas ambientales. *\n• Promueve la recuperación total del cuerpo. *\n• Ayuda a contrarrestar los signos delatores del envejecimiento. *\n• Respalda la agudeza mental saludable. *\n• Promueve la energía y la vitalidad sexual saludables. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para educar al sistema inmunológico. *",
    "ingredientsEn": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor) and 4Life Adaptogenics Blend (Rhaponticum carthamoids root extract, Schisandra chinensis fruit",
    "ingredientsEs": "4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor) and 4Life Adaptogenics Blend (Rhaponticum carthamoids root extract, Schisandra chinensis fruit extract, ALCAR, green tea leaf extract, ashwagandha root extract, turmeric rhizome extract, resveratrol, and black pepper fruit extract).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "120 vegetable capsules",
    "sizeEs": "120 cápsulas vegetales",
    "presentations": [
      {
        "item": "24201",
        "retail": 70.0,
        "discount": 60.0,
        "wholesale": 55.0,
        "lp": 42,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Transfer Factor Renuvo",
      "Renuvo"
    ],
    "isPack": false,
    "sourcePage": 57
  },
  {
    "id": "4LifeTransform Burn",
    "nameEn": "4LifeTransform Burn",
    "nameEs": "4LifeTransform Burn",
    "category": "4LifeTransform",
    "descriptionEn": "PRIMARY SUPPORT: Weight Management *\nScientifically studied thermogenic blend to support accelerated body transformation *\n• Helps adults of all ages achieve a lean, sleek, and healthy body *\n• Supports an accelerated approach to body transformation by igniting fat burning and reducing hunger *\n• Provides energy support to ignite your workouts for optimum performance *",
    "descriptionEs": "RESPALDO PRINCIPAL: Control de peso. *\nMezcla termogénica evaluada científicamente para respaldar la transformación acelerada del cuerpo. *\n• Ayuda a los adultos de todas las edades a lograr un cuerpo, esbelto y saludable. *\n• Respalda un enfoque acelerado para la transformación de cuerpo al impulsar la quema de grasa y reducir el apetito. *\n• Provee respaldo energético para impulsar las rutinas de ejercicios y obtener un rendimiento óptimo. *",
    "ingredientsEn": "Proprietary 4LifeTransform Burn Blend [bitter orange with other citrus (Citrus spp.) fruit extracts, Coleus forskohlii root extract, African mango (Irvingia gabonensis) seed extract, and dihydrocapsiate].",
    "ingredientsEs": "Proprietary 4LifeTransform Burn Blend [bitter orange with other citrus (Citrus spp.) fruit extract, Coleus forskohlii root extract, African mango (Irvingia gabonensis) seed extract, and dihydrocapsiate].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "80 vegetable capsules",
    "sizeEs": "80 cápsulas vegetales",
    "presentations": [
      {
        "item": "27584",
        "retail": 71.0,
        "discount": 60.0,
        "wholesale": 56.0,
        "lp": 38,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4LifeTransform Burn",
      "Burn"
    ],
    "isPack": false,
    "sourcePage": 58
  },
  {
    "id": "ShapeRite",
    "nameEn": "ShapeRite",
    "nameEs": "ShapeRite",
    "category": "4LifeTransform",
    "descriptionEn": "PRIMARY SUPPORT: Weight Management * SECONDARY SUPPORT: Antioxidant, Heart Health, Glucose Metabolism *\nHelps offset the negative effects of high-fat, high-carbohydrate, and starch-heavy meals by binding fats and blocking excess starches and sugars *\n• Aids in fat loss and appetite and weight management *\n• Supports fat and sugar metabolism and balances satiety hormones *\n• Can reduce weight gain caused by excess sugar intake *\n• Supports healthy glucose levels *",
    "descriptionEs": "RESPALDO PRINCIPAL: Control de peso. * RESPALDO SECUNDARIO: Antioxidante. Salud cardiovascular. Metabolismo de la glucosa. *\nAyuda a contrarrestar los efectos negativos de las comidas con alto contenido de grasas, carbohidratos y almidones al comprimir las grasas y bloquear el exceso de almidones y azúcares. *\n• Asiste en la pérdida de grasa, el control del apetito y del peso. *\n• Respalda el metabolismo de las grasas y los azúcares, y equilibra las hormonas de la saciedad. *\n• Puede reducir el aumento de peso causado por el consumo excesivo de azúcar. *\n• Respalda los niveles saludables de glucosa. *",
    "ingredientsEn": "Chitosan (from shellfish), white kidney (Phaseolus vulgaris) bean extract, hydrolyzed yeast (Saccharomyces cerevisiae) extract, dragon fruit (Hylocereus undatus) extract, dicalcium phosphate, and vegetable capsule.",
    "ingredientsEs": "Chitosan (from shellfish), white kidney (Phaseolus vulgaris) bean extract, hydrolyzed yeast (Saccharomyces cerevisiae) extract, dragon fruit (Hylocereus undatus) extract, dicalcium phosphate, and vegetable capsule.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "27598",
        "retail": 44.0,
        "discount": 37.0,
        "wholesale": 35.0,
        "lp": 26,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "ShapeRite"
    ],
    "isPack": false,
    "sourcePage": 58
  },
  {
    "id": "4LifeTransform Woman",
    "nameEn": "4LifeTransform Woman",
    "nameEs": "4LifeTransform Mujer",
    "category": "4LifeTransform",
    "descriptionEn": "PRIMARY SUPPORT: Women’s Health, Healthy Cellular Aging * SECONDARY SUPPORT: Skin Health, Antioxidants *\nFemale support for healthy cellular aging and vibrant living *\n• Supports women’s physical health for a youthful, vibrant life *\n• Supports healthy skin and the body’s production of nitric oxide, which decreases with age *\n• Provides immune system support *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud de la mujer. Envejecimiento celular saludable. * RESPALDO SECUNDARIO: Salud de la piel. Antioxidantes. *\nRespaldo para el envejecimiento celular saludable y un estilo de vida vibrante. *\n• Promueve una vida más juvenil y vibrante al respaldar la salud física de la mujer. *\n• Respalda la salud de la piel y la capacidad del cuerpo de producir óxido nítrico, ya que dicha producción declina con la edad. *\n• Respalda el sistema inmunológico. *",
    "ingredientsEn": "Woman Performance Blend [l-citrulline, evening primrose (Oenothera biennis) defatted seed extract, and velvet bean (Mucuna pruriens) seed extract].",
    "ingredientsEs": "Woman Performance Blend [l-citrulline, evening primrose (Oenothera biennis) defatted seed extract, and velvet bean (Mucuna pruriens) seed extract].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "120 vegetable capsules",
    "sizeEs": "120 cápsulas vegetales",
    "presentations": [
      {
        "item": "27016",
        "retail": 56.0,
        "discount": 48.0,
        "wholesale": 45.0,
        "lp": 32,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4LifeTransform Woman",
      "4LifeTransform Mujer",
      "Woman"
    ],
    "isPack": false,
    "sourcePage": 59
  },
  {
    "id": "4LifeTransform Man",
    "nameEn": "4LifeTransform Man",
    "nameEs": "4LifeTransform Hombre",
    "category": "4LifeTransform",
    "descriptionEn": "PRIMARY SUPPORT: Bone Health, Men’s Health & Vitality * SECONDARY SUPPORT: Healthy Cellular Aging *\nMale health support and healthy aging *\n• Supports healthy cellular aging and antioxidant levels *\n• Optimizes lean muscle growth, mass, and strength *\n• Promotes men’s health and optimal health and well-being *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud de los huesos. Salud y vitalidad del hombre. * RESPALDO SECUNDARIO: Envejecimiento celular saludable. *\nRespaldo para la salud general y el envejecimiento saludable del hombre. *\n• Respalda el envejecimiento celular saludable y los niveles de antioxidantes. *\n• Optimiza el desarrollo de la masa muscular magra y la fuerza. *\n• Promueve la salud del hombre, la salud y el bienestar general óptimo. *",
    "ingredientsEn": "Performance Blend [l-citrulline, citrus peel extract, and Korean ginseng (Panax ginseng) root extract].",
    "ingredientsEs": "Performance Blend [l-citrulline, citrus peel extract, and Korean ginseng (Panax ginseng) root extract].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "120 vegetable capsules",
    "sizeEs": "120 cápsulas vegetales",
    "presentations": [
      {
        "item": "26535",
        "retail": 49.0,
        "discount": 42.0,
        "wholesale": 39.0,
        "lp": 30,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4LifeTransform Man",
      "4LifeTransform Hombre",
      "Man"
    ],
    "isPack": false,
    "sourcePage": 59
  },
  {
    "id": "4LifeTransform Get Burning Pack",
    "nameEn": "4LifeTransform Get Burning Pack",
    "nameEs": "Paquete 4LifeTransform Get Burning para Hombre o Mujer",
    "category": "4LifeTransform",
    "descriptionEn": "4LifeTransform Get Burning † Pack for Women or Men\nPRIMARY SUPPORT: Weight Management, Calorie and Fat Burning, Metabolism * SECONDARY SUPPORT: Immune System, Energy *\nProduct packs for men and women specifically designed to get you energized, help you burn calories, and support general nutrition *\n2—NutraStart Blue Vanilla\n1—RiteStart Women or RiteStart Men\n1—4LifeTransform Burn\n1—Energy Go Stix Berry\nLearn more about these products on pages 36–37 and 50–53.",
    "descriptionEs": "Paquete 4LifeTransform Get Burning † para Hombre o Mujer\nRESPALDO PRINCIPAL: Control de peso. Quema de calorías y grasa. Metabolismo. * RESPALDO SECUNDARIO: Sistema inmunológico. Energía. *\nPaquetes de productos diseñados específicamente para promover la energía, ayudar a quemar calorías y respaldar la nutrición general del hombre o la mujer. *\n2—NutraStart Blue Vanilla\n1—RiteStart Mujer o RiteStart Hombre\n1—4LifeTransform Burn\n1—Energy Go Stix Moras\nMás información de estos productos en las páginas 36–37 y 50–53",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "4LifeTransform Get Burning † Pack",
    "sizeEs": "Paquete 4LifeTransform Get Burning †",
    "presentations": [
      {
        "item": "55676",
        "retail": 372.0,
        "discount": 316.0,
        "wholesale": 250.0,
        "lp": 148,
        "labelEn": "For Women",
        "labelEs": "Para Mujer"
      },
      {
        "item": "55677",
        "retail": 372.0,
        "discount": 316.0,
        "wholesale": 250.0,
        "lp": 148,
        "labelEn": "For Men",
        "labelEs": "Para Hombre"
      }
    ],
    "image": null,
    "aliases": [
      "4LifeTransform Get Burning Pack",
      "4LifeTransform Get Burning Pack for Women or Men",
      "Paquete 4LifeTransform Get Burning para Hombre o Mujer",
      "Get Burning Pack"
    ],
    "isPack": true,
    "sourcePage": 60
  },
  {
    "id": "4LifeTransform Lean and Fit Pack for Women",
    "nameEn": "4LifeTransform Lean and Fit Pack for Women",
    "nameEs": "Paquete 4LifeTransform Lean and Fit para Mujeres",
    "category": "4LifeTransform",
    "descriptionEn": "4LifeTransform Lean and Fit † Pack for Women\nPRIMARY SUPPORT: Muscle, Joints, Workout Recovery * SECONDARY SUPPORT: Immune System; Hair, Skin, & Nails *\nProduct packs to help women optimize their workouts and look and feel their best *\n1—Pro-TF Vanilla Cream or Pro-TF Chocolate\n1—4LifeTransform Burn\n2 — 4Life Transfer Factor Collagen\n1—4LifeTransform PreZoom\n1—4Life Transfer Factor Renuvo\nLearn more about these products on pages 24 and 50–53",
    "descriptionEs": "Paquete 4LifeTransform Lean and Fit † para Mujeres\nRESPALDO PRINCIPAL: Músculos. Articulaciones. Recuperación posterior al ejercicio. * RESPALDO SECUNDARIO: Sistema inmunológico. Cabello, piel y uñas. *\nPaquetes de productos para ayudar a la mujer a optimizar su rutina de ejercicios y verse y sentirse de lo mejor. *\n1—Pro-TF Vainilla o Pro-TF Chocolate\n1—4LifeTransform Burn\n2 — 4Life Transfer Factor Colágeno (fresa y mango)\n1—4LifeTransform PreZoom\n1—4Life Transfer Factor Renuvo\nMás información de estos productos en las páginas 24 y 50–53",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "4LifeTransform Lean and Fit † Pack for Women",
    "sizeEs": "Paquete 4LifeTransform Lean and Fit † para Mujeres",
    "presentations": [
      {
        "item": "55678",
        "retail": 389.0,
        "discount": 331.0,
        "wholesale": 255.0,
        "lp": 145,
        "labelEn": "Vanilla",
        "labelEs": "Vainilla"
      },
      {
        "item": "55775",
        "retail": 389.0,
        "discount": 331.0,
        "wholesale": 255.0,
        "lp": 145,
        "labelEn": "Chocolate",
        "labelEs": "Chocolate"
      }
    ],
    "image": null,
    "aliases": [
      "4LifeTransform Lean and Fit Pack for Women",
      "Paquete 4LifeTransform Lean and Fit para Mujeres",
      "Lean and Fit Pack for Women"
    ],
    "isPack": true,
    "sourcePage": 61
  },
  {
    "id": "4LifeTransform Shred Pack for Men",
    "nameEn": "4LifeTransform Shred Pack for Men",
    "nameEs": "Paquete 4LifeTransform Shred para Hombres",
    "category": "4LifeTransform",
    "descriptionEn": "4LifeTransform Shred † Pack for Men\nPRIMARY SUPPORT: Muscle, Joints, Workout Recovery * SECONDARY SUPPORT: Immune System, Male Health *\nProduct packs to help men optimize their workouts and gain muscle *\n1—Pro-TF Vanilla Cream or Pro-TF Chocolate\n1—4LifeTransform Burn\n1— 4LifeTransform Man\n1—4LifeTransform PreZoom\n1—4Life Transfer Factor Renuvo\nLearn more about these products on pages 50-53",
    "descriptionEs": "Paquete 4LifeTransform Shred † para Hombres\nRESPALDO PRINCIPAL: Músculos. Articulaciones. Recuperación posterior al ejercicio. * RESPALDO SECUNDARIO: Sistema inmunológico. Salud del hombre. *\nPaquetes de productos para ayudar al hombre a optimizar su rutina de ejercicios y desarrollar masa muscular. *\n1—Pro-TF Vainilla o Pro-TF Chocolate\n1—4LifeTransform Burn\n1— 4LifeTransform Hombre\n1—4LifeTransform PreZoom\n1—4Life Transfer Factor Renuvo\nMás información de estos productos en las páginas 50–53",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "4LifeTransform Shred † Pack for Men",
    "sizeEs": "Paquete 4LifeTransform Shred * para Hombres",
    "presentations": [
      {
        "item": "55679",
        "retail": 336.0,
        "discount": 286.0,
        "wholesale": 244.0,
        "lp": 134,
        "labelEn": "Vanilla",
        "labelEs": "Vainilla"
      },
      {
        "item": "55776",
        "retail": 336.0,
        "discount": 286.0,
        "wholesale": 244.0,
        "lp": 134,
        "labelEn": "Chocolate",
        "labelEs": "Chocolate"
      }
    ],
    "image": null,
    "aliases": [
      "4LifeTransform Shred Pack for Men",
      "Paquete 4LifeTransform Shred para Hombres",
      "Shred Pack for Men"
    ],
    "isPack": true,
    "sourcePage": 61
  },
  {
    "id": "Energy Go Stix Berry",
    "nameEn": "Energy Go Stix Berry",
    "nameEs": "Energy Go Stix Moras",
    "category": "Energy",
    "descriptionEn": "PRIMARY SUPPORT: Energy * SECONDARY SUPPORT: Weight Management, Immune System *\nEnergy supplement in ready-to-mix powder packs *\n• Features an energy boost from a synergistic amino acid blend, yerba mate, green tea extract, and three forms of ginseng *\n• Contains 4Life Transfer Factor bioactive immune peptides to support the immune system *",
    "descriptionEs": "RESPALDO PRINCIPAL: Energía. * RESPALDO SECUNDARIO: Control de peso. Sistema inmunológico. *\nSuplemento energético en polvo listo para mezclar que viene en prácticos sobres individuales. *\n• Ofrece un estímulo energizante proveniente de una mezcla sinérgica de aminoácidos, yerba mate, extracto de té verde y tres tipos de ginseng. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para respaldar al sistema inmunológico. *",
    "ingredientsEn": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "ingredientsEs": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 powder packets",
    "sizeEs": "30 sobres",
    "presentations": [
      {
        "item": "27563",
        "retail": 62.0,
        "discount": 53.0,
        "wholesale": 49.0,
        "lp": 36,
        "labelEn": "Berry",
        "labelEs": "Moras"
      }
    ],
    "image": null,
    "aliases": [
      "Energy Go Stix Berry",
      "Energy Go Stix Moras"
    ],
    "isPack": false,
    "sourcePage": 64
  },
  {
    "id": "Energy Go Stix Orange Citrus",
    "nameEn": "Energy Go Stix Orange Citrus",
    "nameEs": "Energy Go Stix Naranja",
    "category": "Energy",
    "descriptionEn": "PRIMARY SUPPORT: Energy * SECONDARY SUPPORT: Weight Management, Immune System *\nEnergy supplement in ready-to-mix powder packs *\n• Features an energy boost from a synergistic amino acid blend, yerba mate, green tea extract, and three forms of ginseng *\n• Contains 4Life Transfer Factor bioactive immune peptides to support the immune system *",
    "descriptionEs": "RESPALDO PRINCIPAL: Energía. * RESPALDO SECUNDARIO: Control de peso. Sistema inmunológico. *\nSuplemento energético en polvo listo para mezclar que viene en prácticos sobres individuales. *\n• Ofrece un estímulo energizante proveniente de una mezcla sinérgica de aminoácidos, yerba mate, extracto de té verde y tres tipos de ginseng. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para respaldar al sistema inmunológico. *",
    "ingredientsEn": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "ingredientsEs": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 powder packets",
    "sizeEs": "30 sobres",
    "presentations": [
      {
        "item": "27572",
        "retail": 62.0,
        "discount": 53.0,
        "wholesale": 49.0,
        "lp": 36,
        "labelEn": "Orange Citrus",
        "labelEs": "Naranja Cítrica"
      }
    ],
    "image": null,
    "aliases": [
      "Energy Go Stix Orange Citrus",
      "Energy Go Stix Naranja"
    ],
    "isPack": false,
    "sourcePage": 64
  },
  {
    "id": "Energy Go Stix Pink Lemonade",
    "nameEn": "Energy Go Stix Pink Lemonade",
    "nameEs": "Energy Go Stix Limonada rosa",
    "category": "Energy",
    "descriptionEn": "PRIMARY SUPPORT: Energy * SECONDARY SUPPORT: Weight Management, Immune System *\nEnergy supplement in ready-to-mix powder packs *\n• Features an energy boost from a synergistic amino acid blend, yerba mate, green tea extract, and three forms of ginseng *\n• Contains 4Life Transfer Factor bioactive immune peptides to support the immune system *",
    "descriptionEs": "RESPALDO PRINCIPAL: Energía. * RESPALDO SECUNDARIO: Control de peso. Sistema inmunológico. *\nSuplemento energético en polvo listo para mezclar que viene en prácticos sobres individuales. *\n• Ofrece un estímulo energizante proveniente de una mezcla sinérgica de aminoácidos, yerba mate, extracto de té verde y tres tipos de ginseng. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para respaldar al sistema inmunológico. *",
    "ingredientsEn": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "ingredientsEs": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "30 powder packets",
    "sizeEs": "30 sobres",
    "presentations": [
      {
        "item": "27575",
        "retail": 62.0,
        "discount": 53.0,
        "wholesale": 49.0,
        "lp": 36,
        "labelEn": "Pink Lemonade",
        "labelEs": "Limonada Rosa"
      }
    ],
    "image": null,
    "aliases": [
      "Energy Go Stix Pink Lemonade",
      "Energy Go Stix Limonada rosa"
    ],
    "isPack": false,
    "sourcePage": 64
  },
  {
    "id": "Energy Go Stix Kiwi Strawberry",
    "nameEn": "Energy Go Stix Kiwi Strawberry",
    "nameEs": "Energy Go Stix Kiwi y fresa",
    "category": "Energy",
    "descriptionEn": "PRIMARY SUPPORT: Energy * SECONDARY SUPPORT: Weight Management, Immune System *\nEnergy supplement in ready-to-mix powder packs *\n• Features an energy boost from a synergistic amino acid blend, yerba mate, green tea extract, and three forms of ginseng *\n• Contains 4Life Transfer Factor bioactive immune peptides to support the immune system *",
    "descriptionEs": "RESPALDO PRINCIPAL: Energía. * RESPALDO SECUNDARIO: Control de peso. Sistema inmunológico. *\nSuplemento energético en polvo listo para mezclar que viene en prácticos sobres individuales. *\n• Ofrece un estímulo energizante proveniente de una mezcla sinérgica de aminoácidos, yerba mate, extracto de té verde y tres tipos de ginseng. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para respaldar al sistema inmunológico. *",
    "ingredientsEn": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "ingredientsEs": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 powder packets",
    "sizeEs": "15 sobres",
    "presentations": [
      {
        "item": "27595",
        "retail": 35.0,
        "discount": 30.0,
        "wholesale": 28.0,
        "lp": 20,
        "labelEn": "Kiwi Strawberry",
        "labelEs": "Kiwi y Fresa"
      }
    ],
    "image": null,
    "aliases": [
      "Energy Go Stix Kiwi Strawberry",
      "Energy Go Stix Kiwi y fresa"
    ],
    "isPack": false,
    "sourcePage": 65
  },
  {
    "id": "Energy Go Stix Tropical",
    "nameEn": "Energy Go Stix Tropical",
    "nameEs": "Energy Go Stix Tropical",
    "category": "Energy",
    "descriptionEn": "PRIMARY SUPPORT: Energy * SECONDARY SUPPORT: Weight Management, Immune System *\nEnergy supplement in ready-to-mix powder packs *\n• Features an energy boost from a synergistic amino acid blend, yerba mate, green tea extract, and three forms of ginseng *\n• Contains 4Life Transfer Factor bioactive immune peptides to support the immune system *",
    "descriptionEs": "RESPALDO PRINCIPAL: Energía. * RESPALDO SECUNDARIO: Control de peso. Sistema inmunológico. *\nSuplemento energético en polvo listo para mezclar que viene en prácticos sobres individuales. *\n• Ofrece un estímulo energizante proveniente de una mezcla sinérgica de aminoácidos, yerba mate, extracto de té verde y tres tipos de ginseng. *\n• Contiene los péptidos inmunológicos bioactivos 4Life Transfer Factor para respaldar al sistema inmunológico. *",
    "ingredientsEn": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "ingredientsEs": "4Life Transfer Factor Blend (UltraFactor and OvoFactor), Amino Acid Blend (l-glutamine, l-arginine, taurine, creatine, l-carnitine, l-omithine, and α-ketoglutarate), Proprietary Blend (eleuthero root extract, Korean ginseng plant extract, and American ginseng root extract), Herbal Energy Blend (green tea leaf extract, yerba mate leaf extract, guarana root extract, maca root extract, and Rhodiola rosea root extract), maltodextrin, natural orange flavor, citric acid, silicon dioxide, beta carotene (color), acesulfame K, sucralose, natural pineapple flavor, and salt.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "15 powder packets",
    "sizeEs": "15 sobres",
    "presentations": [
      {
        "item": "27587",
        "retail": 35.0,
        "discount": 30.0,
        "wholesale": 28.0,
        "lp": 20,
        "labelEn": "Tropical",
        "labelEs": "Tropical"
      }
    ],
    "image": null,
    "aliases": [
      "Energy Go Stix Tropical"
    ],
    "isPack": false,
    "sourcePage": 65
  },
  {
    "id": "Gold Factor",
    "nameEn": "Gold Factor",
    "nameEs": "Gold Factor",
    "category": "4LifeElements",
    "descriptionEn": "PRIMARY SUPPORT: Longevity, Healthy Aging * SECONDARY SUPPORT: Brain Health, Joint Health *\nSupercharge your cells with Gold Factor *\n• Precious: Delicately suspended gold particles refract light, turning the solution an elegant shade of rose\n• Pure: Tested for safety and purity, Gold Factor combines ultra-pure water and intricately shaped particles purer than 24 karat gold\n• Powerful: Every drop contains billions of gold particles that activate your trillions of cells—a true powerhouse of cellular support *\n• Supports joint comfort *†\n• Promotes youthfulness by supporting brain health and memory *^",
    "descriptionEs": "RESPALDO PRINCIPAL: Longevidad. Envejecimiento saludable. * RESPALDO SECUNDARIO: Salud del cerebro. * Salud de las articulaciones. *\nRecarga tus células de energía con Gold Factor. *\n• Precioso—las partículas de oro suspendidas delicadamente refractan la luz, tornando la solución en un elegante color rosa.\n• Puro—sometido a pruebas para determinar su seguridad y pureza, Gold Factor combina agua sumamente pura y partículas de oro de un diseño muy elaborado que son más puras que el oro de 24K.\n• Potente—cada gota contiene miles de millones de partículas de oro que activan tus miles de billones de células. ¡Un respaldo celular verdaderamente potente! *\n• Respalda el bienestar de las articulaciones. *†",
    "ingredientsEn": "Gold (6 ppm).",
    "ingredientsEs": "Gold (6 ppm).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "20 fl oz bottle",
    "sizeEs": "Botella de 20 fl oz",
    "presentations": [
      {
        "item": "28123",
        "retail": 85.0,
        "discount": 72.0,
        "wholesale": 67.0,
        "lp": 53,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Gold Factor"
    ],
    "isPack": false,
    "sourcePage": 67
  },
  {
    "id": "Zinc Factor",
    "nameEn": "Zinc Factor",
    "nameEs": "Zinc Factor",
    "category": "4LifeElements",
    "descriptionEn": "PRIMARY SUPPORT: Immune System *\nRevolutionary mineral solution that combines the immune system support of ionic silver with zinc *\n• Features zinc, which, alone, aids in empowering the function of key immune system cells like T cells *\n• Contains zinc and silver—two minerals that can boost your immune system in times of stress or when you need extra immune system support *\n• One of the only ionic solutions available that features the power of zinc and silver ions for optimal benefits *\n• Formulated through a proprietary electrochemical process and is one of the only ionic solutions available *",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. *\nSolución mineral revolucionaria que combina el respaldo para el sistema inmunológico de la plata iónica con el zinc. *\n• El zinc, por sí solo, asiste con el impulso de la función de células fundamentales del sistema inmunológico, como las células T. *\n• Contiene zinc y plata—dos minerales que pueden impulsar tu sistema inmunológico en momentos de estrés o cuando necesitas un respaldo adicional para el sistema inmunológico. *\n• Es una de las únicas soluciones iónicas disponibles que contiene el poder del zinc y la plata iónica para un beneficio óptimo. *\n• Es formulado mediante un proceso exclusivo electroquímico, y es una de las únicas soluciones iónicas disponibles. *",
    "ingredientsEn": "Zinc (6 ppm) and silver (12 ppm). l-tyrosine, green tea leaf extract, l-theanine, 4Life Tri-Factor Formula (UltraFactor, OvoFactor, and NanoFactor), acesulfame potassium, summer red color, watermelon flavor, maltodextrin, and sucralose.",
    "ingredientsEs": "Zinc (6 ppm) and silver (12 ppm).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "20 fl oz bottle",
    "sizeEs": "Botella de 20 fl oz",
    "presentations": [
      {
        "item": "24127",
        "retail": 82.0,
        "discount": 70.0,
        "wholesale": 65.0,
        "lp": 53,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Zinc Factor"
    ],
    "isPack": false,
    "sourcePage": 67
  },
  {
    "id": "äKwä Oil-to-Foam Cleanser",
    "nameEn": "äKwä Oil-to-Foam Cleanser",
    "nameEs": "äKwä Limpiador de Aceite a Espuma",
    "category": "äKwä Skincare",
    "descriptionEn": "Splash. Rinse. Refresh.\n• Combines fermented green tea water and sea water for a refreshing and effective two-phase cleanser\n• Refines pores with rice ferment and provides nourishing and skin-smoothing enzymes to moisturize and purify your complexion\n• Provides a vegan formula that lifts away debris before transforming into a foaming cleanser",
    "descriptionEs": "Salpica. Enjuaga. Refresca.\n• Combina agua de té verde fermentado y agua de mar para brindar un limpiador refrescante y efectivo de dos fases.\n• Refina los poros con fermento de arroz y aporta enzimas que nutren y suavizan para hidratar y purificar el cutis.\n• Ofrece una fórmula vegana que elimina los residuos antes de convertirse en un limpiador espumoso.",
    "ingredientsEn": "Water, glycerin, dipropylene glycol, coco-betaine, coco-glucoside, acrylates copolymer, polyglyceryl-10 laurate, sodium methyl cocoyl taurate, 1,2-hexanediol, Camellia sinensis leaf water, sea water, rice ferment filtrate (sake), pumpkin (Cucurbita pepo) fruit extract, saccharomyces ferment, bioflavonoids, broccoli (Brassica oleracea italica) extract, Aloe barbadensis leaf extract, sunflower (Helianthus annuus) seed oil, olive (Olea europaea) fruit oil, Geranium maculatum oil, bergamot (Citrus aurantium bergamia) fruit oil, Cymbopogon martinii oil, lavender (Lavandula angustifolia) oil, Citrus junos fruit extract, Pinus densiflora leaf extract, Geranium maculatum nobilis flower oil, Artemisia annua extract, orange (Citrus aurantium dulcis) peel oil, ethylhexylglycerin, potassium cocoyl glycinate, sodium chloride, tromethamine, potassium cocoate, propanediol, caprylic/capric triglyceride, disodium EDTA, sodium lauryl glycol carboxylate, caprylyl glycol, and butylene glycol.",
    "ingredientsEs": "Water, glycerin, dipropylene glycol, coco-betaine, coco-glucoside, acrylates copolymer, polyglyceryl-10 laurate, sodium methyl cocoyl taurate, 1,2-hexanediol, Camellia sinensis leaf water, sea water, rice ferment filtrate (sake), pumpkin (Cucurbita pepo) fruit extract, saccharomyces ferment, bioflavonoids, broccoli (Brassica oleracea italica) extract, Aloe barbadensis leaf extract, sunflower (Helianthus annuus) seed oil, olive (Olea europaea) fruit oil, Geranium maculatum oil, bergamot (Citrus aurantium bergamia) fruit oil, Cymbopogon martinii oil, lavender (Lavandula angustifolia) oil, Citrus junos fruit extract, Pinus densiflora leaf extract, Geranium maculatum nobilis flower oil, Artemisia annua extract, orange (Citrus aurantium dulcis) peel oil, ethylhexylglycerin, potassium cocoyl glycinate, sodium chloride, tromethamine, potassium cocoate, propanediol, caprylic/capric triglyceride, disodium EDTA, sodium lauryl glycol carboxylate, caprylyl glycol, and butylene glycol.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "3.4 fl oz bottle",
    "sizeEs": "Botella de 3.4 fl oz",
    "presentations": [
      {
        "item": "25133",
        "retail": 33.0,
        "discount": 28.0,
        "wholesale": 26.0,
        "lp": 19,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "äKwä Oil-to-Foam Cleanser",
      "äKwä Limpiador de Aceite a Espuma"
    ],
    "isPack": false,
    "sourcePage": 70
  },
  {
    "id": "äKwä Vitamin Serum",
    "nameEn": "äKwä Vitamin Serum",
    "nameEs": "äKwä Sérum de Vitaminas",
    "category": "äKwä Skincare",
    "descriptionEn": "Nourish. Fortify. Brighten.\n• Nourishes and moisturizes your complexion with fermented green tea water and red maple leaf extract\n• Supports a healthy skin surface microbiome and skin conditioning\n• Sustains skin’s environment against daily stressors\n• Infuses your skin with essential vitamins, ferments, and super antioxidants in a vegan formula for a nourished, more youthful-looking complexion",
    "descriptionEs": "Nutre. Fortifica. Da luminosidad.\n• Nutre e hidrata el cutis con agua de té verde fermentado y extracto de hoja de arce rojo.\n• Respalda la microbiota de la superficie de la piel y el acondicionamiento de la piel.\n• Protege el entorno de la piel ante los factores estresantes diarios.\n• Impregna tu piel de vitaminas esenciales, fermentos y excelentes antioxidantes en una fórmula vegana para una tez nutrida y con aspecto más juvenil.",
    "ingredientsEn": "Camellia sinensis leaf water, isopentyldiol, butylene glycol, dipropylene glycol, cetyl ethylhexanoate, methyl gluceth-20, niacinamide, 1,2-hexanediol, polyglyceryl-3 distearate, octyldodecanol, water, saccharomyces ferment, adenosine, ascorbyl glucoside, saccharomyces lysate extract, sugar maple (Acer saccharum) extract, Centella asiatica extract, licorice (Glycyrrhiza glabra) root extract, Scutellaria baicalensis root extract, rosemary (Rosmarinus officinalis) leaf extract, Camellia sinensis leaf extract, Camellia japonica flower extract, arginine, allantoin, panthenol, Citrus unshiu peel extract, Morus nigra fruit extract, Cymbopogon martinii oil, lavender (Lavandula angustifolia) oil, Anthemis nobilis flower oil, matricaria (Chamomilla recutita) flower extract, Geranium maculatum oil, Polygonum cuspidatum root extract, Andrographis paniculata extract, bergamot (Citrus aurantium bergamia) fruit oil, orange (Citrus aurantium dulcis) peel oil, betaine, ethylhexylglycerin, glyceryl stearate citrate, carbomer, propanediol, and caprylyl glycol.",
    "ingredientsEs": "Camellia sinensis leaf water, isopentyldiol, butylene glycol, dipropylene glycol, cetyl ethylhexanoate, methyl gluceth-20, niacinamide, 1,2-hexanediol, polyglyceryl-3 distearate, octyldodecanol, water, saccharomyces ferment, adenosine, ascorbyl glucoside, saccharomyces lysate extract, sugar maple (Acer saccharum) extract, Centella asiatica extract, licorice (Glycyrrhiza glabra) root extract, Scutellaria baicalensis root extract, rosemary (Rosmarinus officinalis) leaf extract, Camellia sinensis leaf extract, Camellia japonica flower extract, arginine, allantoin, panthenol, Citrus unshiu peel extract, Morus nigra fruit extract, Cymbopogon martinii oil, lavender (Lavandula angustifolia) oil, Anthemis nobilis flower oil, matricaria (Chamomilla recutita) flower extract, Geranium maculatum oil, Polygonum cuspidatum root extract, Andrographis paniculata extract, bergamot (Citrus aurantium bergamia) fruit oil, orange (Citrus aurantium dulcis) peel oil, betaine, ethylhexylglycerin, glyceryl stearate citrate, carbomer, propanediol, and caprylyl glycol.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "1.7 fl oz bottle",
    "sizeEs": "Botella de 1.7 fl oz",
    "presentations": [
      {
        "item": "25139",
        "retail": 48.0,
        "discount": 41.0,
        "wholesale": 38.0,
        "lp": 29,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "äKwä Vitamin Serum",
      "äKwä Sérum de Vitaminas"
    ],
    "isPack": false,
    "sourcePage": 70
  },
  {
    "id": "äKwä Refining Eye Cream",
    "nameEn": "äKwä Refining Eye Cream",
    "nameEs": "äKwä Crema Reafirmante de Ojos",
    "category": "äKwä Skincare",
    "descriptionEn": "Polish. Infuse. Firm.\n• Soothes puffiness around the eye area with fermented green tea water, cucumber, and bamboo juice\n• Promotes a smoother, more refined, and more polished outer eye appearance with moisturizers, decadent emollients, and an ancient mushroom that’s naturally rich in plant-derived collagen\n• Offers a vegan formula that settles the appearance of dark circles around the eyes",
    "descriptionEs": "Suaviza. Humecta. Reafirma.\n• Reduce la hinchazón alrededor del área de los ojos con agua de té verde fermentado, pepino y jugo de bambú.\n• Promueve una apariencia más tersa, más suave y fina de la piel del contorno de los ojos, con humectantes, suntuosos emolientes y un hongo ancestral naturalmente rico en colágeno derivado de plantas.\n• Ofrece una fórmula vegana que atenúa la apariencia de las ojeras.",
    "ingredientsEn": "Camellia sinensis leaf water, glycerin, butylene glycol, hydrogenated polydecene, caprylic/capric triglyceride, polyglyceryl-3 distearate, 1,2-hexanediol, cetearyl alcohol, niacinamide, olive (Olea europaea) fruit oil, water, shea (Butyrospermum parkii) butter, mushroom (Tremella fuciformis) extract, sodium hyaluronate, saccharomyces ferment, ascorbyl glucoside, adenosine, cucumber (Cucumis sativus) extract, Bambusa arundinacea juice, Centella asiatica extract, Camellia sinensis leaf extract, Anthemis nobilis flower oil, Polygonum cuspidatum root extract, licorice (Glycyrrhiza glabra) root extract, rosemary (Rosmarinus officinalis) leaf extract, Scutellaria baicalensis root extract, Camellia japonica flower extract, Morus nigra fruit extract, Citrus unshiu peel extract, lavender (Lavandula angustifolia) oil, Andrographis paniculata extract, bergamot (Citrus aurantium bergamia) fruit oil, Geranium maculatum oil, orange (Citrus aurantium dulcis) peel oil, Cymbopogon martinii oil, matricaria (Chamomilla recutita) flower extract, betaine, glyceryl stearate, glyceryl stearate citrate, ethylhexylglycerin, sorbitan isostearate, disodium EDTA, propanediol, behenyl alcohol, polyglyceryl-3 methylglucose distearate, ammonium acryloyldimethyltaurate/VP copolymer, hydroxyethylacrylate/sodium acryloyldimethyl taurate copolymer, and caprylyl glycol.",
    "ingredientsEs": "Camellia sinensis leaf water, glycerin, butylene glycol, hydrogenated polydecene, caprylic/capric triglyceride, polyglyceryl-3 distearate, 1,2-hexanediol, cetearyl alcohol, niacinamide, olive (Olea europaea) fruit oil, water, shea (Butyrospermum parkii) butter, mushroom (Tremella fuciformis) extract, sodium hyaluronate, saccharomyces ferment, ascorbyl glucoside, adenosine, cucumber (Cucumis sativus) extract, Bambusa arundinacea juice, Centella asiatica extract, Camellia sinensis leaf extract, Anthemis nobilis flower oil, Polygonum cuspidatum root extract, licorice (Glycyrrhiza glabra) root extract, rosemary (Rosmarinus extract, Citrus unshiu peel extract, bergamot (Citrus aurantium bergamia) fruit oil, lavender (Lavandula angustifolia) oil, Camellia japonica flower extract, Cymbopogon martinii oil, Geranium maculatum, orange (Citrus aurantium dulcis) peel oil, hydroxyacetophenone, glyceryl stearate, caprylic/capric triglyceride, disodium EDTA, ethylhexylglycerin, microcrystalline wax, glyceryl stearate SE, ammonium acryloyldimethyltaurate/ VP copolymer, propanediol, bis-diglyceryl polyacyladipate-2, caprylyl glycol, pentylene glycol, and dipropylene glycol.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "1 fl oz tube",
    "sizeEs": "Tubo de 1 fl oz",
    "presentations": [
      {
        "item": "25141",
        "retail": 48.0,
        "discount": 42.0,
        "wholesale": 39.0,
        "lp": 30,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "äKwä Refining Eye Cream",
      "äKwä Crema Reafirmante de Ojos"
    ],
    "isPack": false,
    "sourcePage": 71
  },
  {
    "id": "äKwä Moisture Cream",
    "nameEn": "äKwä Moisture Cream",
    "nameEs": "äKwä Crema Humectante",
    "category": "äKwä Skincare",
    "descriptionEn": "Quench. Correct. Firm.\n• Helps calm and reinvent the skin with fermented green tea water, birch tree sap, and ginseng\n• Offers a surge of intense hydration in a light and airy, cloudlike formula\n• Corrects imperfections and reduces the appearance of wrinkles",
    "descriptionEs": "Hidrata. Corrige. Reafirma.\n• Ayuda a calmar y renovar la piel con agua de té verde fermentado, savia de abedul y ginseng.\n• Una fórmula ligera que ofrece una oleada de hidratación intensa.\n• Corrige las imperfecciones y reduce la apariencia de las arrugas.",
    "ingredientsEn": "Camellia sinensis leaf water, water, butylene glycol, cetyl ethylhexanoate, octyldodecanol, glycerin, cetyl alcohol, phytosteryl isostearyl dimer dilinoleate, polyglyceryl-3 methylglucose distearate, jojoba (Simmondsia chinensis) seed oil, niacinamide, hydrogenated vegetable oil, beeswax, 1,2-hexanediol, Panax ginseng root extract, adenosine, Centella asiatica extract, sodium hyaluronate, saccharomyces ferment, honey extract, Andrographis paniculata extract, Betula platyphylla japonica juice, Scutellaria baicalensis root extract, panthenol, Polygonum cuspidatum root extract, Camellia sinensis leaf extract, licorice (Glycyrrhiza glabra) root extract, rosemary (Rosmarinus officinalis) leaf extract, Anthemis nobilis flower oil, Morus nigra fruit extract, matricaria (Chamomilla recutita) flower extract, Citrus unshiu peel extract, bergamot (Citrus aurantium bergamia) fruit oil, lavender (Lavandula angustifolia) oil, Camellia japonica flower extract, Cymbopogon martinii oil, Geranium maculatum, orange (Citrus aurantium dulcis) peel oil, hydroxyacetophenone, glyceryl stearate, caprylic/capric triglyceride, disodium EDTA, ethylhexylglycerin, microcrystalline wax, glyceryl stearate SE, ammonium acryloyldimethyltaurate/VP copolymer, propanediol, bis-diglyceryl polyacyladipate-2, caprylyl glycol, pentylene glycol, and dipropylene glycol.",
    "ingredientsEs": "Camellia sinensis leaf water, water, butylene glycol, cetyl ethylhexanoate, octyldodecanol, glycerin, cetyl alcohol, phytosteryl isostearyl dimer dilinoleate, polyglyceryl-3 methylglucose distearate, jojoba (Simmondsia chinensis) seed oil, niacinamide, hydrogenated vegetable oil, beeswax, 1,2-hexanediol, Panax ginseng root extract, adenosine, Centella asiatica extract, sodium hyaluronate, saccharomyces ferment, honey extract, Andrographis paniculata extract, Betula platyphylla japonica juice, Scutellaria baicalensis root extract, panthenol, Polygonum cuspidatum root extract, Camellia sinensis leaf extract, licorice (Glycyrrhiza glabra) root extract, rosemary (Rosmarinus officinalis) leaf extract, Anthemis nobilis flower oil, Morus nigra fruit extract, matricaria (Chamomilla recutita) flower",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "2.5 oz container",
    "sizeEs": "Envase de 2.5 oz",
    "presentations": [
      {
        "item": "25143",
        "retail": 34.0,
        "discount": 29.0,
        "wholesale": 27.0,
        "lp": 19,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "äKwä Moisture Cream",
      "äKwä Crema Humectante"
    ],
    "isPack": false,
    "sourcePage": 71
  },
  {
    "id": "äKwä SPF 30 Moisturizing Sunscreen",
    "nameEn": "äKwä SPF 30 Moisturizing Sunscreen",
    "nameEs": "äKwä Protector Solar Humectante con FPS 30",
    "category": "äKwä Skincare",
    "descriptionEn": "Shield. Shade. Repel.\n• Creates an environmental veil to repel modern, urban environmental stressors\n• Helps prevent sunburn\n• Features a light, creamy formula that disperses easily and evenly to provide optimal protection",
    "descriptionEs": "Protege. Defiende. Resiste.\n• Crea una capa protectora para repeler los factores estresantes del medio ambiente urbano.\n• Ayuda a prevenir las quemaduras de sol.\n• Contiene una fórmula ligera y cremosa que se dispersa fácil y uniformemente para proporcionar una protección óptima.",
    "ingredientsEn": "Active ingredients: Homosalate, zinc oxide, and octisalate. Inactive ingredients: Water, butyloctyl salicylate, coco-caprylate/ caprate, glycerin, glyceryl stearate, PEG-100 stearate, dimethicone, C14-22 alkane, isododecane, caprylic/capric triglyceride, acrylates/polytrimethylsiloxymethacrylate copolymer, hydroxyapatite, C12-20 alkyl glucoside, cetearyl glucoside, tocopherol, tocopheryl acetate, tetrahexyldecyl ascorbate, triolein, linoleic acid, oleic acid, palmitic acid, stearic acid, bisabolol, phytosteryl canola glycerides, lecithin, xanthan gum, citric acid, biosaccharide gum-4, phenyl trimethicone, caprylyl glycol, polyglyceryl-3 polyricinoleate, disteardimonium hectorite, isostearic acid, disodium EDTA, 1,2 hexanediol, benzyl alcohol, benzoic acid, vinyl dimethicone/ methicone silsesquioxane crosspolymer, ammonium acryloyldimethyltaurate/VP copolymer, propylene carbonate, fragrance, sodium olivoyl glutamate, glucose, farnesol, cetyl alcohol, stearyl alcohol, ethylhexylglycerin, phenoxyethanol, and propylene glycol.",
    "ingredientsEs": "Active ingredients: Homosalate, zinc oxide, and octisalate. Inactive ingredients: Water, butyloctyl salicylate, coco-caprylate/caprate, glycerin, glyceryl stearate, PEG-100 stearate, dimethicone, C14-22 alkane, isododecane, caprylic/capric triglyceride, acrylates/polytrimethylsiloxymethacrylate copolymer, hydroxyapatite, C12-20 alkyl glucoside, cetearyl glucoside, tocopherol, tocopheryl acetate, tetrahexyldecyl ascorbate, triolein, linoleic acid, oleic acid, palmitic acid, stearic acid, bisabolol, phytosteryl canola glycerides, lecithin, xanthan gum, citric acid, biosaccharide gum-4, phenyl trimethicone, caprylyl glycol, polyglyceryl-3 polyricinoleate, disteardimonium hectorite, isostearic acid, disodium EDTA, 1,2 hexanediol, benzyl alcohol, benzoic acid, vinyl dimethicone/ methicone silsesquioxane crosspolymer, ammonium acryloyldimethyltaurate/VP copolymer, propylene carbonate, fragrance, sodium olivoyl glutamate, glucose, farnesol, cetyl alcohol, stearyl alcohol, ethylhexylglycerin, phenoxyethanol, and propylene glycol.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "2 fl oz tube",
    "sizeEs": "Tubo de 2 fl oz",
    "presentations": [
      {
        "item": "25189",
        "retail": 44.0,
        "discount": 37.0,
        "wholesale": 36.0,
        "lp": 27,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "äKwä SPF 30 Moisturizing Sunscreen",
      "äKwä Protector Solar Humectante con FPS 30"
    ],
    "isPack": false,
    "sourcePage": 71
  },
  {
    "id": "enummi Toothpaste",
    "nameEn": "enummi Toothpaste",
    "nameEs": "enummi Pasta Dental",
    "category": "enummi Personal Care",
    "descriptionEn": "A gentle, fluoride-free formula that cleanses teeth and freshens breath without harsh, abrasive agents\n• Dissolves food film for a clean, bright smile\n• Freshens breath\n• Offers a refreshing mint flavor and xylitol\n• Supports oral immunity and the oral microbiome",
    "descriptionEs": "Una fórmula con posbiótico y sin fluoruro que limpia tus dientes y refresca tu aliento sin sustancias fuertes y abrasivas\n• Disuelve la placa de comida para lucir una sonrisa limpia y radiante.\n• Refresca el aliento con un agradable sabor a menta.\n• Ofrece una fórmula libre de fluoruro.",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "4 oz tube",
    "sizeEs": "Tubo de 4 oz",
    "presentations": [
      {
        "item": "25099",
        "retail": 15.0,
        "discount": 13.0,
        "wholesale": 12.0,
        "lp": 5,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "enummi Toothpaste",
      "enummi Pasta Dental"
    ],
    "isPack": false,
    "sourcePage": 74
  },
  {
    "id": "enummi Intensive Body Lotion",
    "nameEn": "enummi Intensive Body Lotion",
    "nameEs": "enummi Loción Corporal",
    "category": "enummi Personal Care",
    "descriptionEn": "Soothing body lotion for healthy skin\n• Contains white tea to protect your skin from the elements\n• Provides a complex range of minerals and amino acids to the skin\n• Promotes soft, smooth skin with aloe vera and shea butter",
    "descriptionEs": "Loción corporal suavizante para mantener la piel saludable.\n• Contiene té blanco para proteger a tu piel de los elementos del medio ambiente.\n• Ofrece a la piel una compleja gama de vitaminas, minerales y aminoácidos.\n• Promueve la suavidad y tersura de la piel con Aloe vera y manteca de karité.",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "8 fl oz tube",
    "sizeEs": "Tubo de 8 fl oz",
    "presentations": [
      {
        "item": "25003",
        "retail": 23.0,
        "discount": 20.0,
        "wholesale": 18.0,
        "lp": 8,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "enummi Intensive Body Lotion",
      "enummi Loción Corporal"
    ],
    "isPack": false,
    "sourcePage": 74
  },
  {
    "id": "enummi Body Wash",
    "nameEn": "enummi Body Wash",
    "nameEs": "enummi Gel de Baño",
    "category": "enummi Personal Care",
    "descriptionEn": "An invigorating cleanser that hydrates the skin\n• Features a light gel formula that creates a luxurious lather with a lively fragrance\n• Leaves skin feeling soft and smooth, without lingering dryness\n• Offers gentle cleansing for the entire family\n• Includes nature-derived ingredients like mango, avocado, and honey extract\n• Combines perfectly with enummi Intensive Body Lotion for ultimate moisturizing benefits",
    "descriptionEs": "Limpiador estimulante que hidrata la piel.\n• Su fórmula ligera en gel crea una lujosa espuma con una exquisita fragancia.\n• Deja la piel sintiéndose suave y sedosa, sin sensación de resequedad.\n• Ofrece una limpieza delicada para la piel de toda la familia.\n• Contiene ingredientes naturales como mango, aguacate y extracto de miel.\n• Al usarse en combinación con enummi Loción Corporal ofrece mayores beneficios hidratantes.",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "11.5 fl oz bottle",
    "sizeEs": "Botella de 11.5 fl oz",
    "presentations": [
      {
        "item": "25111",
        "retail": 24.0,
        "discount": 20.0,
        "wholesale": 19.0,
        "lp": 10,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "enummi Body Wash",
      "enummi Gel de Baño"
    ],
    "isPack": false,
    "sourcePage": 75
  },
  {
    "id": "enummi Shampoo",
    "nameEn": "enummi Shampoo",
    "nameEs": "enummi Champú",
    "category": "enummi Personal Care",
    "descriptionEn": "A sulfate-free, moisture-rich cleansing experience\n• Cleanses gently, yet effectively, with coconut-derived ingredients\n• Includes protein, amino acids, and luscious botanicals\n• Helps prevent color fadeout\n• Provides protection from the environment, manageability, and vibrant shine\n• Works well for daily use on all hair types",
    "descriptionEs": "Una experiencia de limpieza humectante y libre de sulfatos.\n• Limpia suavemente y de manera eficaz con ingredientes derivados del coco.\n• Contiene proteínas, aminoácidos e ingredientes botánicos suntuosos.\n• Ayuda a prevenir la pérdida del color.\n• Ofrece protección contra los elementos ambientales.\n• Mejora la manejabilidad y provee un brillo intenso.\n• Adecuado para el uso diario en todo tipo de cabello.",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "11.5 fl oz bottle",
    "sizeEs": "Botella de 11.5 fl oz",
    "presentations": [
      {
        "item": "25113",
        "retail": 23.0,
        "discount": 20.0,
        "wholesale": 18.0,
        "lp": 10,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "enummi Shampoo",
      "enummi Champú"
    ],
    "isPack": false,
    "sourcePage": 75
  },
  {
    "id": "enummi Conditioner",
    "nameEn": "enummi Conditioner",
    "nameEs": "enummi Acondicionador",
    "category": "enummi Personal Care",
    "descriptionEn": "Conditioner that leaves hair feeling soft and silky\n• Improves manageability and smoothness\n• Saturates hair beautifully and rinses effortlessly, leaving hair feeling soft and silky with a vibrant shine\n• Features a formula rich in protein, vitamins, and amino acids\n• Helps minimize color fading and static, and eases hair and scalp dryness with decadent nature-derived oils and butters\n• Provides environmental protection",
    "descriptionEs": "Deja el cabello con una sensación suave y sedosa.\n• Mejora la manejabilidad y la suavidad.\n• Satura el cabello perfectamente y se enjuaga sin esfuerzo, dejando una sensación de suavidad y brillo intenso.\n• Su fórmula es rica en proteínas, vitaminas y aminoácidos.\n•`Ayuda a minimizar la pérdida del color y la estática, suaviza el cabello y reduce la resequedad del cuero cabelludo con aceites y mantecas de origen natural.\n• Ofrece protección ante los elementos del medio ambiente.",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "8.7 fl oz tube",
    "sizeEs": "Tubo de 8.7 fl oz",
    "presentations": [
      {
        "item": "25118",
        "retail": 18.0,
        "discount": 15.0,
        "wholesale": 14.0,
        "lp": 7,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "enummi Conditioner",
      "enummi Acondicionador"
    ],
    "isPack": false,
    "sourcePage": 75
  },
  {
    "id": "Cal-Mag Complex",
    "nameEn": "Cal-Mag Complex",
    "nameEs": "Cal-Mag Complex",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Muscle, Bone, & Joint Health *\nCalcium and magnesium support for healthy bone metabolism and structural system health *\n• Contains a potent daily serving of more than 600 mg of calcium, 400 IU of vitamin D, and 270 mg of magnesium to support bone health *\n• Contains vital ingredients to support bone growth in people of all ages *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud de los músculos, huesos y articulaciones. *\nCalcio y magnesio para respaldar el metabolismo óseo saludable y la salud del sistema estructural. *\n• Contiene una porción potente de más de 600 mg de calcio, 400 IU de vitamina D y 270 mg de magnesio para respaldar la salud de los huesos. *\n• Incluye ingredientes vitales para respaldar el crecimiento óseo en personas de todas las edades. *",
    "ingredientsEn": "Vitamin C, vitamin D, vitamin K, vitamin B6, calcium, magnesium, zinc, copper, manganese, and Proprietary Blend (boron glycinate, l-lysine, soy lecithin, horsetail aerial parts, and strontium chloride).",
    "ingredientsEs": "Vitamin C, vitamin D, vitamin K, vitamin B6, calcium, magnesium, zinc, copper, manganese, and Proprietary Blend (boron glycinate, l-lysine, soy lecithin, horsetail aerial parts, and strontium chloride).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 tablets",
    "sizeEs": "90 tabletas",
    "presentations": [
      {
        "item": "23520",
        "retail": 22.0,
        "discount": 19.0,
        "wholesale": 17.0,
        "lp": 10,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Cal-Mag Complex"
    ],
    "isPack": false,
    "sourcePage": 78
  },
  {
    "id": "Essential Fatty Acid Complex",
    "nameEn": "Essential Fatty Acid Complex",
    "nameEs": "Essential Fatty Acid Complex",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Brain Health, Heart Health * SECONDARY SUPPORT: Weight Management, Overall Wellness *\nEssential fatty acids for a healthy heart and brain and healthy respiratory function *\n• Features omega-3 and omega-6 fatty acids from fish oil, borage seed oil, flaxseed oil, and safflower seed oil\n• Promotes overall cardiovascular health and strong cell membranes *\n• Contains CLA (conjugated linoleic acid) for cardiovascular and circulatory health *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud del cerebro. Salud cardiovascular. * RESPALDO SECUNDARIO: Control de peso. Bienestar general. *\nÁcidos grasos esenciales para promover la salud cardiovascular, las membranas celulares fuertes y múltiples sistemas del cuerpo. *\n• Contiene ácidos grasos omega-3 y omega-6 provenientes del aceite de pescado, aceite de semilla de borraja, aceite de semilla de linaza y aceite de semilla de cártamo.\n• Promueve la salud cardiovascular general y las membranas celulares fuertes. *\n• Contiene CLA (ácido linoléico conjugado) para la salud cardiovascular y circulatoria. *",
    "ingredientsEn": "Fish Oil Blend (with 500 mg EPA and DHA) and Plant Oil Blend [flaxseed oil (alpha linolenic acid), borage seed oil (gamma linolenic acid), and safflower seed oil (conjugated linoleic acid)].",
    "ingredientsEs": "Fish Oil Blend (with 500 mg EPA and DHA) and Plant Oil Blend [flaxseed oil (alpha linolenic acid), borage seed oil (gamma linolenic acid), and safflower seed oil (conjugated linoleic acid)].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 softgels",
    "sizeEs": "60 cápsulas blandas",
    "presentations": [
      {
        "item": "28095",
        "retail": 31.0,
        "discount": 26.0,
        "wholesale": 25.0,
        "lp": 18,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Essential Fatty Acid Complex"
    ],
    "isPack": false,
    "sourcePage": 78
  },
  {
    "id": "Fibro AMJ Day-Time Formula",
    "nameEn": "Fibro AMJ Day-Time Formula",
    "nameEs": "Fibro AMJ Fórmula Diurna",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Muscle, Bone, & Joint Health *\nScientifically advanced support for structural and nervous system health *\n• Contains powerful metabolites—magnesium and vitamin B6—essential to energy production *\n• Includes glucosamine hydrochloride and methylsulfonylmethane (MSM) for joint support *\n• Includes Boswellia serrata for additional support *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud de los músculos, huesos y articulaciones. *\nRespaldo científicamente avanzado para el sistema nervioso y el sistema estructural. *\n• Contiene potentes metabolitos —magnesio y vitamina B6— esenciales para la producción de energía. *\n• Incluye hidrocloruro de glucosamina y metilsulfonilmetano (MSM) para el respaldo de las articulaciones. *\n• Contiene Boswellia serrata para respaldo adicional. *",
    "ingredientsEn": "Vitamin B6, magnesium, Proprietary Joint Blend (glucosamine hydrochloride, methylsulfonylmethane, bovine cartilage powder, Boswellia serrata tree resin extract, bromelian, and devil’s claw root extract), and Antioxidant Blend (malic acid, n-acetyl-l-cysteine, l-cysteine, grapeseed extract, and alpha lipoic acid).",
    "ingredientsEs": "Vitamin B6, magnesium, Proprietary Joint Blend (glucosamine hydrochloride, methylsulfonylmethane, bovine cartilage powder, Boswellia serrata tree resin extract, bromelian, and devil’s claw root extract), and Antioxidant Blend (malic acid, n-acetyl-l-cysteine, l-cysteine, grapeseed extract, and alpha lipoic acid).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "24501",
        "retail": 34.0,
        "discount": 29.0,
        "wholesale": 27.0,
        "lp": 20,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Fibro AMJ Day-Time Formula",
      "Fibro AMJ Fórmula Diurna"
    ],
    "isPack": false,
    "sourcePage": 79
  },
  {
    "id": "Flex4Life",
    "nameEn": "Flex4Life",
    "nameEs": "Flex4Life",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Muscle, Bone, & Joint Health * SECONDARY SUPPORT: Antioxidant *\nCapsules with nutrients designed to lubricate joints and support a full range of motion *\n• Supports healthy joint tissue, fluids, and overall joint flexibility *\n• Helps maintain mobility for a comfortable, full range of motion *\n• Supports muscle and joint health *\n• Features Terminalia chebula , hyaluronic acid, and turmeric to support healthy knee function *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud de los músculos, huesos y articulaciones. * RESPALDO SECUNDARIO: Antioxidante. *\nCápsulas con nutrientes diseñadas para lubricar las articulaciones y respaldar un rango completo de movimiento. *\n• Respalda el tejido articular saludable, los fluidos y la flexibilidad de las articulaciones en general. *\n• Ayuda a mantener la movilidad para un rango de movimiento cómodo y completo. *\n• Respalda la salud de los músculos y las articulaciones. *\n• Contiene Terminalia chebula , ácido hialurónico y cúrcuma, los cuales han demostrado respaldar el funcionamiento saludable de las rodillas. *",
    "ingredientsEn": "Joint Support Blend [avocado (Persea americana) fruit/soy, Glycine max seed extracts, and hyaluronic acid] and Mobility Support Blend [Terminalia chebula fruit extract, bromelain and trypsin enzymes, turmeric (Curcuma longa) root extracts, Boswellia serrata gum extract, and black pepper (Piper nigrum) fruit extract].",
    "ingredientsEs": "Joint Support Blend [avocado (Persea americana) fruit/soy, Glycine max seed extracts, and hyaluronic acid] and Mobility Support Blend [Terminalia chebula fruit extract, bromelain and trypsin enzymes, turmeric (Curcuma longa) root extracts, Boswellia serrata gum extract, and black pepper (Piper nigrum) fruit extract].",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "23516",
        "retail": 46.0,
        "discount": 39.0,
        "wholesale": 36.0,
        "lp": 24,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Flex4Life"
    ],
    "isPack": false,
    "sourcePage": 79
  },
  {
    "id": "Fortified Colostrum",
    "nameEn": "Fortified Colostrum",
    "nameEs": "Fortified Colostrum",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Immune System, Digestive Health *\nSECONDARY SUPPORT: Respiratory System, Healthy Aging *\nBovine-sourced colostrum to support the immune system, digestive function, and a healthy gut microbiome *\n• Supports immune system function in the digestive tract *\n• May promote healthy brain function *\n• Supports respiratory health *\n• For adults and children four years of age and older",
    "descriptionEs": "RESPALDO PRINCIPAL: Sistema inmunológico. Sistema digestivo. * RESPALDO SECUNDARIO: Sistema respiratorio. Envejecimiento saludable. *\nCalostro de origen bovino para respaldar el sistema inmunológico, la función digestiva y la microbiota intestinal. *\n• Respalda la función del sistema inmunológico en el tracto digestivo. *\n• Puede promover el funcionamiento saludable del cerebro. *\n• Respalda la salud respiratoria. *\n• Para adultos y niños a partir de los cuatro años.",
    "ingredientsEn": "Colostrum powder, lactoferrin, oligosaccharides, alpha lactalbumin, casein glycomacropeptide, high fat whey protein concentrate (MFGM), and silicon dioxide.",
    "ingredientsEs": "Colostrum powder, lactoferrin, oligosaccharides, alpha lactalbumin, casein glycomacropeptide, high fat whey protein concentrate (MFGM), and silicon dioxide.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "28124",
        "retail": 44.0,
        "discount": 37.0,
        "wholesale": 35.0,
        "lp": 26,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Fortified Colostrum"
    ],
    "isPack": false,
    "sourcePage": 80
  },
  {
    "id": "Gurmar",
    "nameEn": "Gurmar",
    "nameEs": "Gurmar",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Glucose Metabolism * SECONDARY SUPPORT: Weight Management *\nAncient Indian herb famous for helping maintain healthy glucose levels *\n• Supports the endocrine system to balance glucose in the body *\n• Helps maintain healthy glucose levels *",
    "descriptionEs": "RESPALDO PRINCIPAL: Metabolismo de la glucosa. * RESPALDO SECUNDARIO: Control de peso. *\nHierba antigua de la India conocida por su capacidad para ayudar a mantener niveles saludables de glucosa. *\n• Respalda el sistema endocrino para equilibrar los niveles de glucosa en el cuerpo. *",
    "ingredientsEn": "Gymnema leaf and gymnema leaf extract.",
    "ingredientsEs": "Gymnema leaf and gymnema leaf extract.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "90 vegetable capsules",
    "sizeEs": "90 cápsulas vegetales",
    "presentations": [
      {
        "item": "4001",
        "retail": 27.5,
        "discount": 23.0,
        "wholesale": 22.0,
        "lp": 17,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Gurmar"
    ],
    "isPack": false,
    "sourcePage": 80
  },
  {
    "id": "Life C Chewable",
    "nameEn": "Life C Chewable",
    "nameEs": "Life C Chewable",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Antioxidant, Multivitamin & Mineral * SECONDARY SUPPORT: Immune System *\nProprietary blend of vitamin C for enhanced absorption and antioxidant support *\n• Features seven active forms of natural vitamin C *\n• Uses varied forms to provide antioxidant protection *\n• Supports the healthy function of multiple body systems *",
    "descriptionEs": "RESPALDO PRINCIPAL: Antioxidante. Multivitaminas y minerales. * RESPALDO SECUNDARIO: Sistema inmunológico. *\nMezcla exclusiva de vitamina C para mejorar la absorción y el respaldo antioxidante. *\n• Contiene siete formas activas de vitamina C natural. *\n• Utiliza diversas formas para proporcionar una protección antioxidante. *\n• Respalda el funcionamiento saludable de múltiples sistemas del cuerpo. *",
    "ingredientsEn": "Vitamin C (as calcium ascorbate, ascorbic acid, dehydroascorbic acid, erythorbic acid, magnesium ascorbate, ascorbyl palmitate, and ascorbigen).",
    "ingredientsEs": "Vitamin C (as calcium ascorbate, ascorbic acid, dehydroascorbic acid, erythorbic acid, magnesium ascorbate, ascorbyl palmitate, and ascorbigen).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 tablets",
    "sizeEs": "60 tabletas",
    "presentations": [
      {
        "item": "28077",
        "retail": 23.0,
        "discount": 20.0,
        "wholesale": 18.0,
        "lp": 10,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Life C Chewable"
    ],
    "isPack": false,
    "sourcePage": 81
  },
  {
    "id": "Menopause Support Formula",
    "nameEn": "Menopause Support Formula",
    "nameEs": "Menopause Support Formula",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Female Health * SECONDARY SUPPORT: Sleep, Mood, & Stress *\nFeatures a blend that balances hormones and moods for basic female support *\n• Contains soy isoflavones, black cohosh, and chaste tree for female health support and healthy hormone levels *\n• Supports a positive mood with black cohosh, l-theanine, and chaste tree fruit extract *\n• Includes antioxidants from quercetin and turmeric *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud de la mujer. * RESPALDO SECUNDARIO: Sueño, estado de ánimo y estrés. *\nFórmula de respaldo para la menopausia, el equilibrio hormonal y el estado anímico. *\n• Contiene isoflavonas de soya, cohosh negro y árbol casto para respaldar el bienestar femenino y los niveles hormonales saludables. *\n• Respalda un buen estado de ánimo con cohosh negro, L-teanina y árbol casto. *\n• Contiene antioxidantes provenientes de la quercetina y la cúrcuma. *",
    "ingredientsEn": "Hormone Balance Blend (soy seed extract, black cohosh root extract, dong quai root extract, chaste tree fruit extract, and turmeric rhizome extract) and Proprietary Female Blend (magnolia bark extract, eleuthero root extract, quercetin, and l-theanine).",
    "ingredientsEs": "Hormone Balance Blend (soy seed extract, black cohosh root extract, dong quai root extract, chaste tree fruit extract, and turmeric rhizome extract) and Proprietary Female Blend (magnolia bark extract, eleuthero root extract, quercetin, and l-theanine).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "22530",
        "retail": 41.0,
        "discount": 35.0,
        "wholesale": 32.0,
        "lp": 22,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Menopause Support Formula"
    ],
    "isPack": false,
    "sourcePage": 81
  },
  {
    "id": "Multiplex",
    "nameEn": "Multiplex",
    "nameEs": "Multiplex",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Multivitamin & Mineral, Overall Wellness *\nBasic daily dose of fundamental vitamins and minerals\n• Features essential vitamins and minerals for general health and wellness *\n• Contains herbal extracts and citrus bioflavonoids to boost energy levels *",
    "descriptionEs": "RESPALDO PRINCIPAL: Multivitaminas y minerales. Bienestar general. *\nLa dosis básica diaria de vitaminas y minerales esenciales. *\n• Contiene vitaminas y minerales esenciales para la salud y el bienestar general. *\n• Incluye extractos de hierbas y bioflavonoides de cítricos para impulsar los niveles de energía. *",
    "ingredientsEn": "Vitamin A, vitamin C, vitamin D, vitamin E, thiamin, riboflavin, niacin, vitamin B6, folic acid, vitamin B12, biotin, pantothenic acid, calcium, iron, iodine, magnesium, zinc, selenium, copper, manganese, chromium, and Proprietary Blend (citrus bioflavonoid fruit complex, spirulina, para-aminobenzoic acid, and rose hips fruit).",
    "ingredientsEs": "Vitamin A, vitamin C, vitamin D, vitamin E, thiamin, riboflavin, niacin, vitamin B6, folic acid, vitamin B12, biotin, pantothenic acid, calcium, iron, iodine, magnesium, zinc, selenium, copper, manganese, chromium, and Proprietary Blend (citrus bioflavonoid fruit complex, spirulina, para-aminobenzoic acid, and rose hips fruit).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "28039",
        "retail": 33.0,
        "discount": 28.0,
        "wholesale": 26.0,
        "lp": 17,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Multiplex"
    ],
    "isPack": false,
    "sourcePage": 82
  },
  {
    "id": "MusculoSkeletal Formula",
    "nameEn": "MusculoSkeletal Formula",
    "nameEs": "MusculoSkeletal Formula",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Muscle, Bone, & Joint Health *\nKey ingredients that support muscle repair *\n• Includes ingredients to support overworked muscles, tendons, ligaments, and nerves *\n• Supports bone structure by reducing bone breakdown *\n• Supports healthy connective tissue *",
    "descriptionEs": "RESPALDO PRINCIPAL: Salud de los músculos, huesos y articulaciones. *\nIngredientes clave que respaldan la reparación de los músculos. *\n• Incluye ingredientes que respaldan los músculos, tendones, ligamentos y nervios desgastados. *\n• Respalda la estructura de los huesos al reducir su deterioro. *\n• Respalda la salud del tejido conectivo. *",
    "ingredientsEn": "Alfalfa aerial parts powder, gotu kola leaf extract, devil’s claw root extract, ginger rhizome powder, turmeric rhizome extract, and saw palmetto fruit extract.",
    "ingredientsEs": "Alfalfa aerial parts powder, gotu kola leaf extract, devil’s claw root extract, ginger rhizome powder, turmeric rhizome extract, and saw palmetto fruit extract.",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "24508",
        "retail": 28.0,
        "discount": 24.0,
        "wholesale": 22.0,
        "lp": 16,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "MusculoSkeletal Formula"
    ],
    "isPack": false,
    "sourcePage": 82
  },
  {
    "id": "Stress Formula",
    "nameEn": "Stress Formula",
    "nameEs": "Stress Formula",
    "category": "4Life Fundamentals",
    "descriptionEn": "PRIMARY SUPPORT: Sleep, Mood, & Stress *\nA calming evening herbal formula to promote relaxation *\n• Contains valerian root to support a calm nervous system *\n• Includes peppermint to soothe stomach discomfort that may be associated with stress *\nthe basics",
    "descriptionEs": "RESPALDO PRINCIPAL: Sueño, estado de ánimo y estrés. *\nUna fórmula herbal calmante para la noche que promueve la relajación. *\n• Contiene raíz de valeriana para respaldar un sistema nervioso tranquilo. *\n• Contiene menta para calmar las molestias del estómago que pudieran estar asociadas con el estrés. *",
    "ingredientsEn": "Proprietary Blend (peppermint leaf, chamomile flower, passion flower, Ginkgo biloba leaf, linden flower, lemon balm leaf, and valerian root) and Stress Proprietary Extract Blend (chamomile flower extract, Ginkgo biloba leaf extract, hops flower extract, peppermint leaf extract, passion flower herb extract, and valerian root extract).",
    "ingredientsEs": "Proprietary Blend (peppermint leaf, chamomile flower, passion flower, Ginkgo biloba leaf, linden flower, lemon balm leaf, and valerian root) and Stress Proprietary Extract Blend (chamomile flower extract, Ginkgo biloba leaf extract, hops flower extract, peppermint leaf extract, passion flower herb extract, and valerian root extract).",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "60 vegetable capsules",
    "sizeEs": "60 cápsulas vegetales",
    "presentations": [
      {
        "item": "22007",
        "retail": 30.0,
        "discount": 26.0,
        "wholesale": 24.0,
        "lp": 16,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "Stress Formula"
    ],
    "isPack": false,
    "sourcePage": 83
  },
  {
    "id": "4Life Fortify",
    "nameEn": "4Life Fortify",
    "nameEs": "4Life Fortify",
    "category": "4Life Service",
    "descriptionEn": "Through our partnership with Feed the Children, you can provide great-tasting meals for children currently experiencing poverty. One bag of 4Life Fortify provides 12–24 meals of rice, lentils, and beans, along with a complete nutritional complex of vitamins, minerals, and 4Life Transfer Factor Tri-Factor Formula to a hungry child. *\n• Provides a protein-rich meal with the texture of a true meal, not simply porridge *\n• Provides proper nutrition for individuals of all ages *\n• Tastes great and can be enjoyed by different cultures around the world\nScan here to learn more about 4Life Fortify",
    "descriptionEs": "A través de nuestra asociación con Feed the Children, es posible brindarles comidas deliciosas a los niños que están atravesando pobreza y hambre. Una bolsa de 4Life Fortify rinde entre 12 y 24 comidas que incluyen arroz, lentejas, frijoles, un complejo nutricional integral de vitaminas y minerales, y además la mezcla 4Life Transfer Factor. *\n• Una comida rica en proteína que tiene una textura de una comida regular, no simplemente de avena. *\n• Ofrece una nutrición adecuada para personas de todas las edades. *\n• Tiene un delicioso sabor que se adapta bien a diferentes culturas alrededor del mundo.\nFoundation 4Life se dedica a servir a nuestra población más vulnerable, los niños, brindándoles los recursos que necesitan para tener una vida plena y satisfactoria. Si deseas contribuir con Foundation 4Life, puedes hacer una donación en 4Life.com o comprar una bolsa de 4Life Fortify.\nEscanea para descubrir más sobre 4Life Fortify",
    "ingredientsEn": "",
    "ingredientsEs": "",
    "directionsEn": null,
    "directionsEs": null,
    "precautionsEn": null,
    "precautionsEs": null,
    "sizeEn": "12−24 servings/bag",
    "sizeEs": "Bolsa de 12 a 24 porciones",
    "presentations": [
      {
        "item": "15005",
        "retail": 48.0,
        "discount": 41.0,
        "wholesale": 40.0,
        "lp": 25,
        "labelEn": "",
        "labelEs": ""
      }
    ],
    "image": null,
    "aliases": [
      "4Life Fortify"
    ],
    "isPack": false,
    "sourcePage": 84
  }
]
''';
