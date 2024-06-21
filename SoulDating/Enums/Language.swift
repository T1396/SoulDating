//
//  Language.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 12.06.24.
//

import Foundation

enum Language: String, CaseIterable {
    case abkhazian = "ab"
    case afar = "aa"
    case afrikaans = "af"
    case akan = "ak"
    case albanian = "sq"
    case amharic = "am"
    case arabic = "ar"
    case aragonese = "an"
    case armenian = "hy"
    case assamese = "as"
    case avaric = "av"
    case avestan = "ae"
    case aymara = "ay"
    case azerbaijani = "az"
    case bambara = "bm"
    case bashkir = "ba"
    case basque = "eu"
    case belarusian = "be"
    case bengali = "bn"
    case bihari = "bh"
    case bislama = "bi"
    case bosnian = "bs"
    case breton = "br"
    case bulgarian = "bg"
    case burmese = "my"
    case catalan = "ca"
    case chamorro = "ch"
    case chechen = "ce"
    case chichewa = "ny"
    case chinese = "zh"
    case chuvash = "cv"
    case cornish = "kw"
    case corsican = "co"
    case cree = "cr"
    case croatian = "hr"
    case czech = "cs"
    case danish = "da"
    case dhivehi = "dv"
    case dutch = "nl"
    case dzongkha = "dz"
    case english = "en"
    case esperanto = "eo"
    case estonian = "et"
    case ewe = "ee"
    case faroese = "fo"
    case fijian = "fj"
    case finnish = "fi"
    case french = "fr"
    case fulah = "ff"
    case galician = "gl"
    case georgian = "ka"
    case german = "de"
    case greek = "el"
    case guarani = "gn"
    case gujarati = "gu"
    case haitian = "ht"
    case hausa = "ha"
    case hebrew = "he"
    case herero = "hz"
    case hindi = "hi"
    case hiriMotu = "ho"
    case hungarian = "hu"
    case interlingua = "ia"
    case indonesian = "id"
    case interlingue = "ie"
    case irish = "ga"
    case igbo = "ig"
    case inupiaq = "ik"
    case ido = "io"
    case icelandic = "is"
    case italian = "it"
    case inuktitut = "iu"
    case japanese = "ja"
    case javanese = "jv"
    case kalaallisut = "kl"
    case kannada = "kn"
    case kanuri = "kr"
    case kashmiri = "ks"
    case kazakh = "kk"
    case khmer = "km"
    case kikuyu = "ki"
    case kinyarwanda = "rw"
    case kirghiz = "ky"
    case komi = "kv"
    case kongo = "kg"
    case korean = "ko"
    case kurdish = "ku"
    case kwanyama = "kj"
    case latin = "la"
    case luxembourgish = "lb"
    case ganda = "lg"
    case limburgan = "li"
    case lingala = "ln"
    case lao = "lo"
    case lithuanian = "lt"
    case lubaKatanga = "lu"
    case latvian = "lv"
    case malagasy = "mg"
    case marshallese = "mh"
    case maori = "mi"
    case macedonian = "mk"
    case malayalam = "ml"
    case mongolian = "mn"
    case marathi = "mr"
    case malay = "ms"
    case maltese = "mt"
    case burmese = "my"
    case nauru = "na"
    case bokmal = "nb"
    case northNdebele = "nd"
    case nepali = "ne"
    case ndonga = "ng"
    case dutch = "nl"
    case norwegianNynorsk = "nn"
    case norwegian = "no"
    case southNdebele = "nr"
    case navajo = "nv"
    case chichewa = "ny"
    case occitan = "oc"
    case ojibwa = "oj"
    case oromo = "om"
    case oriya = "or"
    case ossetian = "os"
    case panjabi = "pa"
    case pali = "pi"
    case polish = "pl"
    case pashto = "ps"
    case portuguese = "pt"
    case quechua = "qu"
    case romansh = "rm"
    case rundi = "rn"
    case romanian = "ro"
    case russian = "ru"
    case kinyarwanda = "rw"
    case sanskrit = "sa"
    case sardinian = "sc"
    case sindhi = "sd"
    case northernSami = "se"
    case samoan = "sm"
    case sango = "sg"
    case serbian = "sr"
    case gaelic = "gd"
    case shona = "sn"
    case sinhala = "si"
    case slovak = "sk"
    case slovenian = "sl"
    case somali = "so"
    case southernSotho = "st"
    case spanish = "es"
    case sundanese = "su"
    case swahili = "sw"
    case swati = "ss"
    case swedish = "sv"
    case tamil = "ta"
    case telugu = "te"
    case tajik = "tg"
    case thai = "th"
    case tigrinya = "ti"
    case tibetan = "bo"
    case turkmen = "tk"
    case tagalog = "tl"
    case tswana = "tn"
    case tonga = "to"
    case turkish = "tr"
    case tsonga = "ts"
    case tatar = "tt"
    case twi = "tw"
    case tahitian = "ty"
    case uighur = "ug"
    case ukrainian = "uk"
    case urdu = "ur"
    case uzbek = "uz"
    case venda = "ve"
    case vietnamese = "vi"
    case volapuk = "vo"
    case walloon = "wa"
    case wolof = "wo"
    case xhosa = "xh"
    case yiddish = "yi"
    case yoruba = "yo"
    case zhuang = "za"
    case zulu = "zu"
    
    var displayName: String {
        self.rawValue.capitalized
    }
}

