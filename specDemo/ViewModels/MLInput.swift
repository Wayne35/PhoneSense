//
//  MLInput.swift
//  specDemo
//
//  Created by Yiyum on 2023/4/5.
//

import Foundation
import CoreML

class MLInput {
    
    static func initMLInput() -> Beer_svm_modelInput?{
        
        //var dataArray = [Double](repeating: 0, count:800)
        //var dataArray: [Double] = []
//
//        guard let csvPath = Bundle.main.path(forResource: "155429", ofType: "csv") else {
//            return nil
//        }
        
        // 读取 CSV 文件
//        guard let csv = try? String(contentsOfFile: csvPath, encoding: .utf8) else {
//            return nil
//        }
        
        // 将 CSV 转换为一个 [[String]] 数组
//        let lines = csv.components(separatedBy: .newlines)
//        var data: [[String]] = []
//        for line in lines {
//            data.append(line.components(separatedBy: ","))
//        }
        
        // 将 [[String]] 转换为 [[String: Double]]
        
//        for j in 0..<data[0].count {
//            if let value = Double(data[0][j]) {
//                dataArray[j] = value // 特征名字为 1~800
//            }
//        }
        
         let dataArray = SPEC_DATA_CLASSIFY
        //print(1)
        
        let mlarray = try! MLMultiArray(shape: [1, 800], dataType: .double)
        for i in 0..<800 {
            mlarray[i] = NSNumber(value: dataArray[i])
        }
        
        let originInput = Beer_svm_modelInput(input: mlarray)
        
//        let originInput = bearPredictorInput(_1: dataArray[0], _2: dataArray[1], _3: dataArray[2], _4: dataArray[3], _5: dataArray[4], _6: dataArray[5], _7: dataArray[6], _8: dataArray[7], _9: dataArray[8], _10: dataArray[9],
//                                             _11: dataArray[10], _12: dataArray[11], _13: dataArray[12], _14: dataArray[13], _15: dataArray[14], _16: dataArray[15], _17: dataArray[16], _18: dataArray[17], _19: dataArray[18], _20: dataArray[19],
//                                             _21: dataArray[20], _22: dataArray[21], _23: dataArray[22], _24: dataArray[23], _25: dataArray[24], _26: dataArray[25], _27: dataArray[26], _28: dataArray[27], _29: dataArray[28], _30: dataArray[29],
//                                             _31: dataArray[30], _32: dataArray[31], _33: dataArray[32], _34: dataArray[33], _35: dataArray[34], _36: dataArray[35], _37: dataArray[36], _38: dataArray[37], _39: dataArray[38], _40: dataArray[39],
//                                             _41: dataArray[40], _42: dataArray[41], _43: dataArray[42], _44: dataArray[43], _45: dataArray[44], _46: dataArray[45], _47: dataArray[46], _48: dataArray[47], _49: dataArray[48], _50: dataArray[49],
//                                             _51: dataArray[50], _52: dataArray[51], _53: dataArray[52], _54: dataArray[53], _55: dataArray[54], _56: dataArray[55], _57: dataArray[56], _58: dataArray[57], _59: dataArray[58], _60: dataArray[59],
//                                             _61: dataArray[60], _62: dataArray[61], _63: dataArray[62], _64: dataArray[63], _65: dataArray[64], _66: dataArray[65], _67: dataArray[66], _68: dataArray[67], _69: dataArray[68], _70: dataArray[69],
//                                             _71: dataArray[70], _72: dataArray[71], _73: dataArray[72], _74: dataArray[73], _75: dataArray[74], _76: dataArray[75], _77: dataArray[76], _78: dataArray[77], _79: dataArray[78], _80: dataArray[79],
//                                             _81: dataArray[80], _82: dataArray[81], _83: dataArray[82], _84: dataArray[83], _85: dataArray[84], _86: dataArray[85], _87: dataArray[86], _88: dataArray[87], _89: dataArray[88], _90: dataArray[89],
//                                             _91: dataArray[90], _92: dataArray[91], _93: dataArray[92], _94: dataArray[93], _95: dataArray[94], _96: dataArray[95], _97: dataArray[96], _98: dataArray[97], _99: dataArray[98], _100: dataArray[99],
//                                             _101: dataArray[100], _102: dataArray[101], _103: dataArray[102], _104: dataArray[103], _105: dataArray[104], _106: dataArray[105], _107: dataArray[106], _108: dataArray[107], _109: dataArray[108], _110: dataArray[109],
//                                             _111: dataArray[110], _112: dataArray[111], _113: dataArray[112], _114: dataArray[113], _115: dataArray[114], _116: dataArray[115], _117: dataArray[116], _118: dataArray[117], _119: dataArray[118], _120: dataArray[119],
//                                             _121: dataArray[120], _122: dataArray[121], _123: dataArray[122], _124: dataArray[123], _125: dataArray[124], _126: dataArray[125], _127: dataArray[126], _128: dataArray[127], _129: dataArray[128], _130: dataArray[129],
//                                             _131: dataArray[130], _132: dataArray[131], _133: dataArray[132], _134: dataArray[133], _135: dataArray[134], _136: dataArray[135], _137: dataArray[136], _138: dataArray[137], _139: dataArray[138], _140: dataArray[139],
//                                             _141: dataArray[140], _142: dataArray[141], _143: dataArray[142], _144: dataArray[143], _145: dataArray[144], _146: dataArray[145], _147: dataArray[146], _148: dataArray[147], _149: dataArray[148], _150: dataArray[149],
//                                             _151: dataArray[150], _152: dataArray[151], _153: dataArray[152], _154: dataArray[153], _155: dataArray[154], _156: dataArray[155], _157: dataArray[156], _158: dataArray[157], _159: dataArray[158], _160: dataArray[159],
//                                             _161: dataArray[160], _162: dataArray[161], _163: dataArray[162], _164: dataArray[163], _165: dataArray[164], _166: dataArray[165], _167: dataArray[166], _168: dataArray[167], _169: dataArray[168], _170: dataArray[169],
//                                             _171: dataArray[170], _172: dataArray[171], _173: dataArray[172], _174: dataArray[173], _175: dataArray[174], _176: dataArray[175], _177: dataArray[176], _178: dataArray[177], _179: dataArray[178], _180: dataArray[179],
//                                             _181: dataArray[180], _182: dataArray[181], _183: dataArray[182], _184: dataArray[183], _185: dataArray[184], _186: dataArray[185], _187: dataArray[186], _188: dataArray[187], _189: dataArray[188], _190: dataArray[189],
//                                             _191: dataArray[190], _192: dataArray[191], _193: dataArray[192], _194: dataArray[193], _195: dataArray[194], _196: dataArray[195], _197: dataArray[196], _198: dataArray[197], _199: dataArray[198], _200: dataArray[199],
//                                             _201: dataArray[200], _202: dataArray[201], _203: dataArray[202], _204: dataArray[203], _205: dataArray[204], _206: dataArray[205], _207: dataArray[206], _208: dataArray[207], _209: dataArray[208], _210: dataArray[209],
//                                             _211: dataArray[210], _212: dataArray[211], _213: dataArray[212], _214: dataArray[213], _215: dataArray[214], _216: dataArray[215], _217: dataArray[216], _218: dataArray[217], _219: dataArray[218], _220: dataArray[219],
//                                             _221: dataArray[220], _222: dataArray[221], _223: dataArray[222], _224: dataArray[223], _225: dataArray[224], _226: dataArray[225], _227: dataArray[226], _228: dataArray[227], _229: dataArray[228], _230: dataArray[229],
//                                             _231: dataArray[230], _232: dataArray[231], _233: dataArray[232], _234: dataArray[233], _235: dataArray[234], _236: dataArray[235], _237: dataArray[236], _238: dataArray[237], _239: dataArray[238], _240: dataArray[239],
//                                             _241: dataArray[240], _242: dataArray[241], _243: dataArray[242], _244: dataArray[243], _245: dataArray[244], _246: dataArray[245], _247: dataArray[246], _248: dataArray[247], _249: dataArray[248], _250: dataArray[249],
//                                             _251: dataArray[250], _252: dataArray[251], _253: dataArray[252], _254: dataArray[253], _255: dataArray[254], _256: dataArray[255], _257: dataArray[256], _258: dataArray[257], _259: dataArray[258], _260: dataArray[259],
//                                             _261: dataArray[260], _262: dataArray[261], _263: dataArray[262], _264: dataArray[263], _265: dataArray[264], _266: dataArray[265], _267: dataArray[266], _268: dataArray[267], _269: dataArray[268], _270: dataArray[269],
//                                             _271: dataArray[270], _272: dataArray[271], _273: dataArray[272], _274: dataArray[273], _275: dataArray[274], _276: dataArray[275], _277: dataArray[276], _278: dataArray[277], _279: dataArray[278], _280: dataArray[279],
//                                             _281: dataArray[280], _282: dataArray[281], _283: dataArray[282], _284: dataArray[283], _285: dataArray[284], _286: dataArray[285], _287: dataArray[286], _288: dataArray[287], _289: dataArray[288], _290: dataArray[289],
//                                             _291: dataArray[290], _292: dataArray[291], _293: dataArray[292], _294: dataArray[293], _295: dataArray[294], _296: dataArray[295], _297: dataArray[296], _298: dataArray[297], _299: dataArray[298], _300: dataArray[299],
//                                             _301: dataArray[300], _302: dataArray[301], _303: dataArray[302], _304: dataArray[303], _305: dataArray[304], _306: dataArray[305], _307: dataArray[306], _308: dataArray[307], _309: dataArray[308], _310: dataArray[309],
//                                             _311: dataArray[310], _312: dataArray[311], _313: dataArray[312], _314: dataArray[313], _315: dataArray[314], _316: dataArray[315], _317: dataArray[316], _318: dataArray[317], _319: dataArray[318], _320: dataArray[319],
//                                             _321: dataArray[320], _322: dataArray[321], _323: dataArray[322], _324: dataArray[323], _325: dataArray[324], _326: dataArray[325], _327: dataArray[326], _328: dataArray[327], _329: dataArray[328], _330: dataArray[329],
//                                             _331: dataArray[330], _332: dataArray[331], _333: dataArray[332], _334: dataArray[333], _335: dataArray[334], _336: dataArray[335], _337: dataArray[336], _338: dataArray[337], _339: dataArray[338], _340: dataArray[339],
//                                             _341: dataArray[340], _342: dataArray[341], _343: dataArray[342], _344: dataArray[343], _345: dataArray[344], _346: dataArray[345], _347: dataArray[346], _348: dataArray[347], _349: dataArray[348], _350: dataArray[349],
//                                             _351: dataArray[350], _352: dataArray[351], _353: dataArray[352], _354: dataArray[353], _355: dataArray[354], _356: dataArray[355], _357: dataArray[356], _358: dataArray[357], _359: dataArray[358], _360: dataArray[359],
//                                             _361: dataArray[360], _362: dataArray[361], _363: dataArray[362], _364: dataArray[363], _365: dataArray[364], _366: dataArray[365], _367: dataArray[366], _368: dataArray[367], _369: dataArray[368], _370: dataArray[369],
//                                             _371: dataArray[370], _372: dataArray[371], _373: dataArray[372], _374: dataArray[373], _375: dataArray[374], _376: dataArray[375], _377: dataArray[376], _378: dataArray[377], _379: dataArray[378], _380: dataArray[379],
//                                             _381: dataArray[380], _382: dataArray[381], _383: dataArray[382], _384: dataArray[383], _385: dataArray[384], _386: dataArray[385], _387: dataArray[386], _388: dataArray[387], _389: dataArray[388], _390: dataArray[389],
//                                             _391: dataArray[390], _392: dataArray[391], _393: dataArray[392], _394: dataArray[393], _395: dataArray[394], _396: dataArray[395], _397: dataArray[396], _398: dataArray[397], _399: dataArray[398], _400: dataArray[399],
//                                             _401: dataArray[400], _402: dataArray[401], _403: dataArray[402], _404: dataArray[403], _405: dataArray[404], _406: dataArray[405], _407: dataArray[406], _408: dataArray[407], _409: dataArray[408], _410: dataArray[409],
//                                             _411: dataArray[410], _412: dataArray[411], _413: dataArray[412], _414: dataArray[413], _415: dataArray[414], _416: dataArray[415], _417: dataArray[416], _418: dataArray[417], _419: dataArray[418], _420: dataArray[419],
//                                             _421: dataArray[420], _422: dataArray[421], _423: dataArray[422], _424: dataArray[423], _425: dataArray[424], _426: dataArray[425], _427: dataArray[426], _428: dataArray[427], _429: dataArray[428], _430: dataArray[429],
//                                             _431: dataArray[430], _432: dataArray[431], _433: dataArray[432], _434: dataArray[433], _435: dataArray[434], _436: dataArray[435], _437: dataArray[436], _438: dataArray[437], _439: dataArray[438], _440: dataArray[439],
//                                             _441: dataArray[440], _442: dataArray[441], _443: dataArray[442], _444: dataArray[443], _445: dataArray[444], _446: dataArray[445], _447: dataArray[446], _448: dataArray[447], _449: dataArray[448], _450: dataArray[449],
//                                             _451: dataArray[450], _452: dataArray[451], _453: dataArray[452], _454: dataArray[453], _455: dataArray[454], _456: dataArray[455], _457: dataArray[456], _458: dataArray[457], _459: dataArray[458], _460: dataArray[459],
//                                             _461: dataArray[460], _462: dataArray[461], _463: dataArray[462], _464: dataArray[463], _465: dataArray[464], _466: dataArray[465], _467: dataArray[466], _468: dataArray[467], _469: dataArray[468], _470: dataArray[469],
//                                             _471: dataArray[470], _472: dataArray[471], _473: dataArray[472], _474: dataArray[473], _475: dataArray[474], _476: dataArray[475], _477: dataArray[476], _478: dataArray[477], _479: dataArray[478], _480: dataArray[479],
//                                             _481: dataArray[480], _482: dataArray[481], _483: dataArray[482], _484: dataArray[483], _485: dataArray[484], _486: dataArray[485], _487: dataArray[486], _488: dataArray[487], _489: dataArray[488], _490: dataArray[489],
//                                             _491: dataArray[490], _492: dataArray[491], _493: dataArray[492], _494: dataArray[493], _495: dataArray[494], _496: dataArray[495], _497: dataArray[496], _498: dataArray[497], _499: dataArray[498], _500: dataArray[499],
//                                             _501: dataArray[500], _502: dataArray[501], _503: dataArray[502], _504: dataArray[503], _505: dataArray[504], _506: dataArray[505], _507: dataArray[506], _508: dataArray[507], _509: dataArray[508], _510: dataArray[509],
//                                             _511: dataArray[510], _512: dataArray[511], _513: dataArray[512], _514: dataArray[513], _515: dataArray[514], _516: dataArray[515], _517: dataArray[516], _518: dataArray[517], _519: dataArray[518], _520: dataArray[519],
//                                             _521: dataArray[520], _522: dataArray[521], _523: dataArray[522], _524: dataArray[523], _525: dataArray[524], _526: dataArray[525], _527: dataArray[526], _528: dataArray[527], _529: dataArray[528], _530: dataArray[529],
//                                             _531: dataArray[530], _532: dataArray[531], _533: dataArray[532], _534: dataArray[533], _535: dataArray[534], _536: dataArray[535], _537: dataArray[536], _538: dataArray[537], _539: dataArray[538], _540: dataArray[539],
//                                             _541: dataArray[540], _542: dataArray[541], _543: dataArray[542], _544: dataArray[543], _545: dataArray[544], _546: dataArray[545], _547: dataArray[546], _548: dataArray[547], _549: dataArray[548], _550: dataArray[549],
//                                             _551: dataArray[550], _552: dataArray[551], _553: dataArray[552], _554: dataArray[553], _555: dataArray[554], _556: dataArray[555], _557: dataArray[556], _558: dataArray[557], _559: dataArray[558], _560: dataArray[559],
//                                             _561: dataArray[560], _562: dataArray[561], _563: dataArray[562], _564: dataArray[563], _565: dataArray[564], _566: dataArray[565], _567: dataArray[566], _568: dataArray[567], _569: dataArray[568], _570: dataArray[569],
//                                             _571: dataArray[570], _572: dataArray[571], _573: dataArray[572], _574: dataArray[573], _575: dataArray[574], _576: dataArray[575], _577: dataArray[576], _578: dataArray[577], _579: dataArray[578], _580: dataArray[579],
//                                             _581: dataArray[580], _582: dataArray[581], _583: dataArray[582], _584: dataArray[583], _585: dataArray[584], _586: dataArray[585], _587: dataArray[586], _588: dataArray[587], _589: dataArray[588], _590: dataArray[589],
//                                             _591: dataArray[590], _592: dataArray[591], _593: dataArray[592], _594: dataArray[593], _595: dataArray[594], _596: dataArray[595], _597: dataArray[596], _598: dataArray[597], _599: dataArray[598], _600: dataArray[599],
//                                             _601: dataArray[600], _602: dataArray[601], _603: dataArray[602], _604: dataArray[603], _605: dataArray[604], _606: dataArray[605], _607: dataArray[606], _608: dataArray[607], _609: dataArray[608], _610: dataArray[609],
//                                             _611: dataArray[610], _612: dataArray[611], _613: dataArray[612], _614: dataArray[613], _615: dataArray[614], _616: dataArray[615], _617: dataArray[616], _618: dataArray[617], _619: dataArray[618], _620: dataArray[619],
//                                             _621: dataArray[620], _622: dataArray[621], _623: dataArray[622], _624: dataArray[623], _625: dataArray[624], _626: dataArray[625], _627: dataArray[626], _628: dataArray[627], _629: dataArray[628], _630: dataArray[629],
//                                             _631: dataArray[630], _632: dataArray[631], _633: dataArray[632], _634: dataArray[633], _635: dataArray[634], _636: dataArray[635], _637: dataArray[636], _638: dataArray[637], _639: dataArray[638], _640: dataArray[639],
//                                             _641: dataArray[640], _642: dataArray[641], _643: dataArray[642], _644: dataArray[643], _645: dataArray[644], _646: dataArray[645], _647: dataArray[646], _648: dataArray[647], _649: dataArray[648], _650: dataArray[649],
//                                             _651: dataArray[650], _652: dataArray[651], _653: dataArray[652], _654: dataArray[653], _655: dataArray[654], _656: dataArray[655], _657: dataArray[656], _658: dataArray[657], _659: dataArray[658], _660: dataArray[659],
//                                             _661: dataArray[660], _662: dataArray[661], _663: dataArray[662], _664: dataArray[663], _665: dataArray[664], _666: dataArray[665], _667: dataArray[666], _668: dataArray[667], _669: dataArray[668], _670: dataArray[669],
//                                             _671: dataArray[670], _672: dataArray[671], _673: dataArray[672], _674: dataArray[673], _675: dataArray[674], _676: dataArray[675], _677: dataArray[676], _678: dataArray[677], _679: dataArray[678], _680: dataArray[679],
//                                             _681: dataArray[680], _682: dataArray[681], _683: dataArray[682], _684: dataArray[683], _685: dataArray[684], _686: dataArray[685], _687: dataArray[686], _688: dataArray[687], _689: dataArray[688], _690: dataArray[689],
//                                             _691: dataArray[690], _692: dataArray[691], _693: dataArray[692], _694: dataArray[693], _695: dataArray[694], _696: dataArray[695], _697: dataArray[696], _698: dataArray[697], _699: dataArray[698], _700: dataArray[699],
//                                             _701: dataArray[700], _702: dataArray[701], _703: dataArray[702], _704: dataArray[703], _705: dataArray[704], _706: dataArray[705], _707: dataArray[706], _708: dataArray[707], _709: dataArray[708], _710: dataArray[709],
//                                             _711: dataArray[710], _712: dataArray[711], _713: dataArray[712], _714: dataArray[713], _715: dataArray[714], _716: dataArray[715], _717: dataArray[716], _718: dataArray[717], _719: dataArray[718], _720: dataArray[719],
//                                             _721: dataArray[720], _722: dataArray[721], _723: dataArray[722], _724: dataArray[723], _725: dataArray[724], _726: dataArray[725], _727: dataArray[726], _728: dataArray[727], _729: dataArray[728], _730: dataArray[729],
//                                             _731: dataArray[730], _732: dataArray[731], _733: dataArray[732], _734: dataArray[733], _735: dataArray[734], _736: dataArray[735], _737: dataArray[736], _738: dataArray[737], _739: dataArray[738], _740: dataArray[739],
//                                             _741: dataArray[740], _742: dataArray[741], _743: dataArray[742], _744: dataArray[743], _745: dataArray[744], _746: dataArray[745], _747: dataArray[746], _748: dataArray[747], _749: dataArray[748], _750: dataArray[749],
//                                             _751: dataArray[750], _752: dataArray[751], _753: dataArray[752], _754: dataArray[753], _755: dataArray[754], _756: dataArray[755], _757: dataArray[756], _758: dataArray[757], _759: dataArray[758], _760: dataArray[759],
//                                             _761: dataArray[760], _762: dataArray[761], _763: dataArray[762], _764: dataArray[763], _765: dataArray[764], _766: dataArray[765], _767: dataArray[766], _768: dataArray[767], _769: dataArray[768], _770: dataArray[769],
//                                             _771: dataArray[770], _772: dataArray[771], _773: dataArray[772], _774: dataArray[773], _775: dataArray[774], _776: dataArray[775], _777: dataArray[776], _778: dataArray[777], _779: dataArray[778], _780: dataArray[779],
//                                             _781: dataArray[780], _782: dataArray[781], _783: dataArray[782], _784: dataArray[783], _785: dataArray[784], _786: dataArray[785], _787: dataArray[786], _788: dataArray[787], _789: dataArray[788], _790: dataArray[789],
//                                             _791: dataArray[790], _792: dataArray[791], _793: dataArray[792], _794: dataArray[793], _795: dataArray[794], _796: dataArray[795], _797: dataArray[796], _798: dataArray[797], _799: dataArray[798], _800: dataArray[799])
        return originInput
    }
}



