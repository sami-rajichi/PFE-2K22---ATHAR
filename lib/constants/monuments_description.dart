const Map<String, dynamic> descriptions = 
  {
    'north': {
      'carthage-amphi': [
        "L'amphithéâtre de Carthage est un amphithéâtre romain construit au 1er siècle dans la ville de Carthage, reconstruite par Jules César (Colonia Julia Karthago) et qui devient la capitale de la province romaine d'Afrique.",
        "156 m * 128 m",
        "65m * 37m * 2,5m",
        "30 000 places",
      ],
      'aqueduc-zaghouan': [
        "L'aqueduc de Zaghouan, ou aqueduc de Carthage, est un aqueduc romain reliant Carthage aux sources de la région de Zaghouan (Tunisie). Restauré au xixe siècle, cet ouvrage est le seul de cette importance existant en Tunisie avant l'instauration du protectorat français.",
        "132 km",
        "Eau Portable",
        "122",
      ]
    },
    
    'middle': {
      'el-jem': [
      "L'amphithéâtre d'El Jem (arabe : مسرح الجم), aussi appelé Colisée de Thysdrus, est un amphithéâtre romain situé dans l'actuelle ville tunisienne d'El Jem, l'antique Thysdrus de la province romaine d'Afrique.",
      "148 m × 122 m",
      "65 m × 39 m",
      "27 000 places",
    ],
    }
  };

countMonuments(){
   int count = 0;
   for(var k in descriptions.keys){
      count += descriptions[k].length as int;
   }
   return count;
}

var count = countMonuments();