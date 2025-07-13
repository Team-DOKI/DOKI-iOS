//
//  ActivityAreaMapView.swift
//  PAWKEY
//
//  Created by 이세민 on 7/10/25.
//

import SwiftUI
import MapKit

struct ActivityAreaMapView: View {
    @EnvironmentObject var router: Coordinator<HomeScreen>
    @EnvironmentObject var tabBarState: TabBarState
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5215, longitude: 127.0250),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var activityAreas: [ActivityArea] = []
    @State private var showToast = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PolygonMapView(region: region, polygons: activityAreas.map { $0.coordinates })
                .edgesIgnoringSafeArea(.all)
            
            if showToast {
                ToastMessage(message: "지역을 강남구 역삼동으로 변경했어요.")
                    .transition(.opacity)
                    .padding(.bottom, 246 + 22)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Color.pawkeyWhite1
                    .frame(height: 246)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .overlay(
                        VStack(alignment: .leading) {
                            HStack {
                                Text("선택한 위치")
                                    .font(.head_20_b)
                                    .foregroundColor(.pawkeyBlack)
                                Spacer()
                                Text("신사동")
                                    .font(.head_20_b)
                                    .foregroundColor(.green500)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 32)
                            .padding(.bottom, 18)
                            
                            Text("기존에 산책하던 지역은 0000이에요.\n선택한 위치로 산책 지역을 변경하시겠어요?")
                                .font(.body_14_m)
                                .foregroundColor(.gray500)
                                .padding(.top, 12)
                                .padding(.horizontal, 16)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            CTAButton(title: "지역 변경하기") {
                                withAnimation {
                                    showToast = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showToast = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        router.reset()
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 32)
                            .padding(.bottom, 30)
                        }
                            .overlay(alignment: .bottom, content: {
                                Rectangle()
                                    .foregroundStyle(.white)
                                    .frame(height: 100)
                                    .offset(y: 95)
                            })
                    )
            }
        }
        .topNavigationView(left: {
            BackButton {
                router.pop()
            }
        }, center: {
            Text("내 동네 설정")
                .font(.body_16_sb)
        })
        .onAppear {
            loadActivityAreas()
        }
    }
    
    // 임시 신사동 좌표
    func loadActivityAreas() {
        let ring1: [CLLocationCoordinate2D] = [
            CLLocationCoordinate2D(latitude: 37.50451590775723, longitude: 127.04898636795214),
            CLLocationCoordinate2D(latitude: 37.50405518487715, longitude: 127.04920396473153),
            CLLocationCoordinate2D(latitude: 37.502703428171785, longitude: 127.04984242979425),
            CLLocationCoordinate2D(latitude: 37.50135166771985, longitude: 127.05048087185993),
            CLLocationCoordinate2D(latitude: 37.50120832679624, longitude: 127.05054863257367),
            CLLocationCoordinate2D(latitude: 37.499999903521825, longitude: 127.05111929093087),
            CLLocationCoordinate2D(latitude: 37.4986481355783, longitude: 127.05175768700921),
            CLLocationCoordinate2D(latitude: 37.49729636388483, longitude: 127.05239607140555),
            CLLocationCoordinate2D(latitude: 37.496425874994834, longitude: 127.05280717194877),
            CLLocationCoordinate2D(latitude: 37.496307882944194, longitude: 127.05286293170572),
            CLLocationCoordinate2D(latitude: 37.49628847265156, longitude: 127.0528070779838),
            CLLocationCoordinate2D(latitude: 37.495945116192566, longitude: 127.05180960182973),
            CLLocationCoordinate2D(latitude: 37.49550951004735, longitude: 127.05054490682252),
            CLLocationCoordinate2D(latitude: 37.4947304949838, longitude: 127.04828278260689),
            CLLocationCoordinate2D(latitude: 37.49459522059964, longitude: 127.04788992429302),
            CLLocationCoordinate2D(latitude: 37.494191351605096, longitude: 127.04671700171832),
            CLLocationCoordinate2D(latitude: 37.493981007275636, longitude: 127.04602072289056),
            CLLocationCoordinate2D(latitude: 37.49328694166792, longitude: 127.04375873958179),
            CLLocationCoordinate2D(latitude: 37.49324531881141, longitude: 127.04362320285159),
            CLLocationCoordinate2D(latitude: 37.49259283264771, longitude: 127.04149679810035),
            CLLocationCoordinate2D(latitude: 37.4924035503918, longitude: 127.04088024530711),
            CLLocationCoordinate2D(latitude: 37.492400729791704, longitude: 127.04088165729247),
            CLLocationCoordinate2D(latitude: 37.49189530146896, longitude: 127.03923489674992),
            CLLocationCoordinate2D(latitude: 37.491201105633024, longitude: 127.03697303903292),
            CLLocationCoordinate2D(latitude: 37.491147098156915, longitude: 127.03679756578937),
            CLLocationCoordinate2D(latitude: 37.49061263635391, longitude: 127.03505667877334),
            CLLocationCoordinate2D(latitude: 37.49054512368893, longitude: 127.03483632303148),
            CLLocationCoordinate2D(latitude: 37.49045988608702, longitude: 127.03455820150437),
            CLLocationCoordinate2D(latitude: 37.49031432080857, longitude: 127.03455707449243),
            CLLocationCoordinate2D(latitude: 37.490277188335774, longitude: 127.0344360349911),
            CLLocationCoordinate2D(latitude: 37.49020517331889, longitude: 127.03420190642547),
            CLLocationCoordinate2D(latitude: 37.49015903861046, longitude: 127.03405135108986),
            CLLocationCoordinate2D(latitude: 37.490139630448425, longitude: 127.03398808916968),
            CLLocationCoordinate2D(latitude: 37.4900856185242, longitude: 127.03381263186276),
            CLLocationCoordinate2D(latitude: 37.490049889596996, longitude: 127.03369618449298),
            CLLocationCoordinate2D(latitude: 37.49004595588419, longitude: 127.0336827496508),
            CLLocationCoordinate2D(latitude: 37.49000600472891, longitude: 127.03355305967816),
            CLLocationCoordinate2D(latitude: 37.48998715439328, longitude: 127.03349174311965),
            CLLocationCoordinate2D(latitude: 37.48995649339756, longitude: 127.0333915468781),
            CLLocationCoordinate2D(latitude: 37.489918513450256, longitude: 127.03326804316978),
            CLLocationCoordinate2D(latitude: 37.48991626275461, longitude: 127.03326132565142),
            CLLocationCoordinate2D(latitude: 37.489850439242154, longitude: 127.03304610781245),
            CLLocationCoordinate2D(latitude: 37.48982343254394, longitude: 127.03295863421936),
            CLLocationCoordinate2D(latitude: 37.489712587984926, longitude: 127.03259728499452),
            CLLocationCoordinate2D(latitude: 37.489622285667394, longitude: 127.03230308802924),
            CLLocationCoordinate2D(latitude: 37.489532261610535, longitude: 127.03201011307272),
            CLLocationCoordinate2D(latitude: 37.48945005722889, longitude: 127.03196396857243),
            CLLocationCoordinate2D(latitude: 37.48963591135346, longitude: 127.0318753494837),
            CLLocationCoordinate2D(latitude: 37.4895548888142, longitude: 127.03161154010932),
            CLLocationCoordinate2D(latitude: 37.49795288016765, longitude: 127.02760125254851),
            CLLocationCoordinate2D(latitude: 37.50447759463318, longitude: 127.02448491510636),
            CLLocationCoordinate2D(latitude: 37.50471902133801, longitude: 127.02528319673851),
            CLLocationCoordinate2D(latitude: 37.504835793343695, longitude: 127.02566988634281),
            CLLocationCoordinate2D(latitude: 37.50541343053395, longitude: 127.02758493809415),
            CLLocationCoordinate2D(latitude: 37.50551809443595, longitude: 127.02793204663288),
            CLLocationCoordinate2D(latitude: 37.50620035211509, longitude: 127.03019424807346),
            CLLocationCoordinate2D(latitude: 37.50676385451449, longitude: 127.03206183960043),
            CLLocationCoordinate2D(latitude: 37.50688285469716, longitude: 127.03245649078069),
            CLLocationCoordinate2D(latitude: 37.50731213210318, longitude: 127.03387977921363),
            CLLocationCoordinate2D(latitude: 37.50756530484966, longitude: 127.0347187746463),
            CLLocationCoordinate2D(latitude: 37.508114108401955, longitude: 127.03653906062249),
            CLLocationCoordinate2D(latitude: 37.508247441280226, longitude: 127.0369810995431),
            CLLocationCoordinate2D(latitude: 37.50869719463769, longitude: 127.03847214129424),
            CLLocationCoordinate2D(latitude: 37.5089233264142, longitude: 127.03924346245577),
            CLLocationCoordinate2D(latitude: 37.50946416872323, longitude: 127.04108661187595),
            CLLocationCoordinate2D(latitude: 37.50958706773011, longitude: 127.04150585967602),
            CLLocationCoordinate2D(latitude: 37.51025076561907, longitude: 127.04376829692514),
            CLLocationCoordinate2D(latitude: 37.51027551304533, longitude: 127.04385207584185),
            CLLocationCoordinate2D(latitude: 37.50947436542458, longitude: 127.0441497628822),
            CLLocationCoordinate2D(latitude: 37.50946310136927, longitude: 127.04415416749224),
            CLLocationCoordinate2D(latitude: 37.509384252895025, longitude: 127.04418522593078),
            CLLocationCoordinate2D(latitude: 37.509295544437016, longitude: 127.04422476139189),
            CLLocationCoordinate2D(latitude: 37.50920796987832, longitude: 127.04426800717093),
            CLLocationCoordinate2D(latitude: 37.5091217905, longitude: 127.04431497471622),
            CLLocationCoordinate2D(latitude: 37.50903645663203, longitude: 127.04436582204671),
            CLLocationCoordinate2D(latitude: 37.50895309457747, longitude: 127.04442038014211),
            CLLocationCoordinate2D(latitude: 37.50887114577886, longitude: 127.04447846771096),
            CLLocationCoordinate2D(latitude: 37.508790592202885, longitude: 127.04454010735492),
            CLLocationCoordinate2D(latitude: 37.50871201042855, longitude: 127.04460544642986),
            CLLocationCoordinate2D(latitude: 37.508635400639946, longitude: 127.04467396466136),
            CLLocationCoordinate2D(latitude: 37.5085607627612, longitude: 127.0447458543179),
            CLLocationCoordinate2D(latitude: 37.50848809686091, longitude: 127.0448209118123),
            CLLocationCoordinate2D(latitude: 37.508417393914776, longitude: 127.04489915975638),
            CLLocationCoordinate2D(latitude: 37.508348942302334, longitude: 127.04498041735235),
            CLLocationCoordinate2D(latitude: 37.508283030340614, longitude: 127.0450646734567),
            CLLocationCoordinate2D(latitude: 37.50821908138095, longitude: 127.04515193904444),
            CLLocationCoordinate2D(latitude: 37.50815795156503, longitude: 127.04524167172936),
            CLLocationCoordinate2D(latitude: 37.50811118059369, longitude: 127.04531516005598),
            CLLocationCoordinate2D(latitude: 37.507673362422025, longitude: 127.04602884973482),
            CLLocationCoordinate2D(latitude: 37.50687774504047, longitude: 127.04732637014827),
            CLLocationCoordinate2D(latitude: 37.50681942378095, longitude: 127.04741839708399),
            CLLocationCoordinate2D(latitude: 37.506758851188536, longitude: 127.04750725572652),
            CLLocationCoordinate2D(latitude: 37.50669490041475, longitude: 127.04759450614625),
            CLLocationCoordinate2D(latitude: 37.50662926601884, longitude: 127.04767840765919),
            CLLocationCoordinate2D(latitude: 37.50656138017589, longitude: 127.04775948017165),
            CLLocationCoordinate2D(latitude: 37.50649095463889, longitude: 127.04783755385829),
            CLLocationCoordinate2D(latitude: 37.506418566198725, longitude: 127.04791225585188),
            CLLocationCoordinate2D(latitude: 37.506344205704934, longitude: 127.04798395937493),
            CLLocationCoordinate2D(latitude: 37.506267873309916, longitude: 127.04805229120693),
            CLLocationCoordinate2D(latitude: 37.50618985725829, longitude: 127.04811745510841),
            CLLocationCoordinate2D(latitude: 37.50610986938351, longitude: 127.04817907768243),
            CLLocationCoordinate2D(latitude: 37.506028477314985, longitude: 127.04823717059894),
            CLLocationCoordinate2D(latitude: 37.505948204625724, longitude: 127.04828977885096),
            CLLocationCoordinate2D(latitude: 37.50594539351335, longitude: 127.04828977709722),
            CLLocationCoordinate2D(latitude: 37.505860904130984, longitude: 127.0483423826012),
            CLLocationCoordinate2D(latitude: 37.50577472302057, longitude: 127.04838951301451),
            CLLocationCoordinate2D(latitude: 37.50568770543574, longitude: 127.0484329332055),
            CLLocationCoordinate2D(latitude: 37.50540693783995, longitude: 127.04856546536),
            CLLocationCoordinate2D(latitude: 37.50451590775723, longitude: 127.04898636795214)
        ]
        
        //        let ring2: [CLLocationCoordinate2D] = [
        //            CLLocationCoordinate2D(latitude: 37.522605348868, longitude: 127.01318773696728),
        //            CLLocationCoordinate2D(latitude: 37.522586194511874, longitude: 127.01317960045584),
        //            CLLocationCoordinate2D(latitude: 37.52258796070942, longitude: 127.01317710071716),
        //            CLLocationCoordinate2D(latitude: 37.52259182651724, longitude: 127.01317164880014),
        //            CLLocationCoordinate2D(latitude: 37.52262676328338, longitude: 127.01311904079898),
        //            CLLocationCoordinate2D(latitude: 37.52265982568028, longitude: 127.01306924921995),
        //            CLLocationCoordinate2D(latitude: 37.522750776447694, longitude: 127.01293229387471),
        //            CLLocationCoordinate2D(latitude: 37.522878493009884, longitude: 127.01273917804974),
        //            CLLocationCoordinate2D(latitude: 37.5229634510042, longitude: 127.01261041114844),
        //            CLLocationCoordinate2D(latitude: 37.52297621091163, longitude: 127.01259106894084),
        //            CLLocationCoordinate2D(latitude: 37.523387627731445, longitude: 127.011948970083),
        //            CLLocationCoordinate2D(latitude: 37.52345362551245, longitude: 127.01184775583278),
        //            CLLocationCoordinate2D(latitude: 37.52359530778524, longitude: 127.01163044094803),
        //            CLLocationCoordinate2D(latitude: 37.523746181017174, longitude: 127.01139864651478),
        //            CLLocationCoordinate2D(latitude: 37.52427043541193, longitude: 127.01059531089771),
        //            CLLocationCoordinate2D(latitude: 37.52448092304767, longitude: 127.01027463651133),
        //            CLLocationCoordinate2D(latitude: 37.524769417366876, longitude: 127.00983513015997),
        //            CLLocationCoordinate2D(latitude: 37.52487976493087, longitude: 127.00966695761956),
        //            CLLocationCoordinate2D(latitude: 37.524934434013005, longitude: 127.00958363471199),
        //            CLLocationCoordinate2D(latitude: 37.52518532353923, longitude: 127.00920095406983),
        //            CLLocationCoordinate2D(latitude: 37.525356952499386, longitude: 127.00894351731921),
        //            CLLocationCoordinate2D(latitude: 37.52539341918812, longitude: 127.00888881270578),
        //            CLLocationCoordinate2D(latitude: 37.52559503575671, longitude: 127.00857826409263),
        //            CLLocationCoordinate2D(latitude: 37.52560105405098, longitude: 127.00858413596852),
        //            CLLocationCoordinate2D(latitude: 37.525603198294114, longitude: 127.00858621771383),
        //            CLLocationCoordinate2D(latitude: 37.52577099835366, longitude: 127.00875504253904),
        //            CLLocationCoordinate2D(latitude: 37.52584955116615, longitude: 127.00883495222979),
        //            CLLocationCoordinate2D(latitude: 37.52589961627903, longitude: 127.00888589856191),
        //            CLLocationCoordinate2D(latitude: 37.52591261680786, longitude: 127.00889912448108),
        //            CLLocationCoordinate2D(latitude: 37.52598779112633, longitude: 127.00897371712523),
        //            CLLocationCoordinate2D(latitude: 37.526379699442096, longitude: 127.00935062113959),
        //            CLLocationCoordinate2D(latitude: 37.52647401832642, longitude: 127.00944431283939),
        //            CLLocationCoordinate2D(latitude: 37.526613095480016, longitude: 127.00958309141903),
        //            CLLocationCoordinate2D(latitude: 37.52689914167713, longitude: 127.0098652327395),
        //            CLLocationCoordinate2D(latitude: 37.52694710744606, longitude: 127.00991017306919),
        //            CLLocationCoordinate2D(latitude: 37.526985577350864, longitude: 127.00994619778814),
        //            CLLocationCoordinate2D(latitude: 37.52700302845431, longitude: 127.00996246776681),
        //            CLLocationCoordinate2D(latitude: 37.52701147918971, longitude: 127.00997077242218),
        //            CLLocationCoordinate2D(latitude: 37.52704188559012, longitude: 127.01000100405848),
        //            CLLocationCoordinate2D(latitude: 37.52712486177668, longitude: 127.01007607496851),
        //            CLLocationCoordinate2D(latitude: 37.52713451079627, longitude: 127.01008479836692),
        //            CLLocationCoordinate2D(latitude: 37.52730568843064, longitude: 127.01023967016279),
        //            CLLocationCoordinate2D(latitude: 37.527528228215054, longitude: 127.01043887318278),
        //            CLLocationCoordinate2D(latitude: 37.52757231088968, longitude: 127.01047833828532),
        //            CLLocationCoordinate2D(latitude: 37.527650565909696, longitude: 127.01054876002549),
        //            CLLocationCoordinate2D(latitude: 37.52861654246639, longitude: 127.01141815928894),
        //            CLLocationCoordinate2D(latitude: 37.529536047894155, longitude: 127.01229082121961),
        //            CLLocationCoordinate2D(latitude: 37.52963517403132, longitude: 127.01240267918185),
        //            CLLocationCoordinate2D(latitude: 37.52968018300957, longitude: 127.01245347134815),
        //            CLLocationCoordinate2D(latitude: 37.528601224474116, longitude: 127.01365142555142),
        //            CLLocationCoordinate2D(latitude: 37.52681610161861, longitude: 127.01552808510908),
        //            CLLocationCoordinate2D(latitude: 37.52681256026685, longitude: 127.01553181770923),
        //            CLLocationCoordinate2D(latitude: 37.52680176500444, longitude: 127.01554316254344),
        //            CLLocationCoordinate2D(latitude: 37.52667369978025, longitude: 127.01567613296743),
        //            CLLocationCoordinate2D(latitude: 37.5265905085456, longitude: 127.01577097576873),
        //            CLLocationCoordinate2D(latitude: 37.52633717920901, longitude: 127.01603941531508),
        //            CLLocationCoordinate2D(latitude: 37.52631114613811, longitude: 127.01606650452257),
        //            CLLocationCoordinate2D(latitude: 37.526133564377844, longitude: 127.01624987337651),
        //            CLLocationCoordinate2D(latitude: 37.526132753379585, longitude: 127.01625069905245),
        //            CLLocationCoordinate2D(latitude: 37.526005885913996, longitude: 127.01638171020404),
        //            CLLocationCoordinate2D(latitude: 37.526002692534995, longitude: 127.0163407120044),
        //            CLLocationCoordinate2D(latitude: 37.52571197544113, longitude: 127.01606790407621),
        //            CLLocationCoordinate2D(latitude: 37.52562261768386, longitude: 127.01597083475319),
        //            CLLocationCoordinate2D(latitude: 37.525378919674885, longitude: 127.01572268891722),
        //            CLLocationCoordinate2D(latitude: 37.52524892889576, longitude: 127.01560772743848),
        //            CLLocationCoordinate2D(latitude: 37.52518446980101, longitude: 127.01554817673046),
        //            CLLocationCoordinate2D(latitude: 37.52503150658847, longitude: 127.01540678524151),
        //            CLLocationCoordinate2D(latitude: 37.52500059723926, longitude: 127.01537454979194),
        //            CLLocationCoordinate2D(latitude: 37.52493477863022, longitude: 127.01530550793254),
        //            CLLocationCoordinate2D(latitude: 37.52484852680746, longitude: 127.01522447107588),
        //            CLLocationCoordinate2D(latitude: 37.524762167445175, longitude: 127.01513791383411),
        //            CLLocationCoordinate2D(latitude: 37.524657996875575, longitude: 127.01503801602962),
        //            CLLocationCoordinate2D(latitude: 37.52459269085717, longitude: 127.0149757850476),
        //            CLLocationCoordinate2D(latitude: 37.52457617739731, longitude: 127.01496017072262),
        //            CLLocationCoordinate2D(latitude: 37.524569880119586, longitude: 127.01495421917681),
        //            CLLocationCoordinate2D(latitude: 37.52455459181331, longitude: 127.01494033590487),
        //            CLLocationCoordinate2D(latitude: 37.52454651973124, longitude: 127.01493300391056),
        //            CLLocationCoordinate2D(latitude: 37.52449809622241, longitude: 127.01488915904295),
        //            CLLocationCoordinate2D(latitude: 37.52437900585256, longitude: 127.01478131788424),
        //            CLLocationCoordinate2D(latitude: 37.52428412263585, longitude: 127.0146957443872),
        //            CLLocationCoordinate2D(latitude: 37.52420135665983, longitude: 127.01461990199341),
        //            CLLocationCoordinate2D(latitude: 37.52414589702212, longitude: 127.01456916698295),
        //            CLLocationCoordinate2D(latitude: 37.52411436539628, longitude: 127.01454016752949),
        //            CLLocationCoordinate2D(latitude: 37.524094653571794, longitude: 127.01452249396887),
        //            CLLocationCoordinate2D(latitude: 37.52404397724533, longitude: 127.01448023299112),
        //            CLLocationCoordinate2D(latitude: 37.52399527390675, longitude: 127.0144395787845),
        //            CLLocationCoordinate2D(latitude: 37.523977814207086, longitude: 127.01442508447562),
        //            CLLocationCoordinate2D(latitude: 37.52397041770508, longitude: 127.01441897445822),
        //            CLLocationCoordinate2D(latitude: 37.52395275979378, longitude: 127.01440438962494),
        //            CLLocationCoordinate2D(latitude: 37.52394477772159, longitude: 127.01439756682453),
        //            CLLocationCoordinate2D(latitude: 37.52394262454323, longitude: 127.01439573383212),
        //            CLLocationCoordinate2D(latitude: 37.52392685855598, longitude: 127.014382642582),
        //            CLLocationCoordinate2D(latitude: 37.52391813770718, longitude: 127.01437544634763),
        //            CLLocationCoordinate2D(latitude: 37.52390715556339, longitude: 127.01436638316827),
        //            CLLocationCoordinate2D(latitude: 37.52388362361475, longitude: 127.01434758911307),
        //            CLLocationCoordinate2D(latitude: 37.52387196574947, longitude: 127.01433827695197),
        //            CLLocationCoordinate2D(latitude: 37.52384155076264, longitude: 127.01431423275332),
        //            CLLocationCoordinate2D(latitude: 37.52383395602476, longitude: 127.01430822453635),
        //            CLLocationCoordinate2D(latitude: 37.52380608162862, longitude: 127.01428611522607),
        //            CLLocationCoordinate2D(latitude: 37.523785279436424, longitude: 127.01426959549032),
        //            CLLocationCoordinate2D(latitude: 37.52377736937722, longitude: 127.01426331572975),
        //            CLLocationCoordinate2D(latitude: 37.52373570191668, longitude: 127.01423025365715),
        //            CLLocationCoordinate2D(latitude: 37.523695719553864, longitude: 127.01419489547996),
        //            CLLocationCoordinate2D(latitude: 37.52369346733202, longitude: 127.01419241767331),
        //            CLLocationCoordinate2D(latitude: 37.523688458358755, longitude: 127.01418720178893),
        //            CLLocationCoordinate2D(latitude: 37.523684458385745, longitude: 127.01418304944555),
        //            CLLocationCoordinate2D(latitude: 37.52366997203203, longitude: 127.0141676733881),
        //            CLLocationCoordinate2D(latitude: 37.523664467576964, longitude: 127.01416183523916),
        //            CLLocationCoordinate2D(latitude: 37.523650936280085, longitude: 127.01414641410112),
        //            CLLocationCoordinate2D(latitude: 37.523621954792205, longitude: 127.01411339953172),
        //            CLLocationCoordinate2D(latitude: 37.52358260308661, longitude: 127.01407807551358),
        //            CLLocationCoordinate2D(latitude: 37.52356097230938, longitude: 127.0140581620185),
        //            CLLocationCoordinate2D(latitude: 37.52346430494864, longitude: 127.01396913978981),
        //            CLLocationCoordinate2D(latitude: 37.52334098819898, longitude: 127.01385987552396),
        //            CLLocationCoordinate2D(latitude: 37.52327960957089, longitude: 127.01380065640048),
        //            CLLocationCoordinate2D(latitude: 37.52321622225854, longitude: 127.01373597316994),
        //            CLLocationCoordinate2D(latitude: 37.52311519527555, longitude: 127.01363288979958),
        //            CLLocationCoordinate2D(latitude: 37.523056150248536, longitude: 127.01357230262175),
        //            CLLocationCoordinate2D(latitude: 37.52303551981023, longitude: 127.01354923342872),
        //            CLLocationCoordinate2D(latitude: 37.52301103354485, longitude: 127.01352186494026),
        //            CLLocationCoordinate2D(latitude: 37.52297471932156, longitude: 127.0134736120049),
        //            CLLocationCoordinate2D(latitude: 37.522967198025185, longitude: 127.0134537010936),
        //            CLLocationCoordinate2D(latitude: 37.52295670423872, longitude: 127.01342588239186),
        //            CLLocationCoordinate2D(latitude: 37.52291344311414, longitude: 127.0133795062848),
        //            CLLocationCoordinate2D(latitude: 37.522862036399154, longitude: 127.01333887560536),
        //            CLLocationCoordinate2D(latitude: 37.522809737755495, longitude: 127.01329753216575),
        //            CLLocationCoordinate2D(latitude: 37.5227199236227, longitude: 127.01323636375943),
        //            CLLocationCoordinate2D(latitude: 37.522605348868, longitude: 127.01318773696728)
        //        ]
        
        let area = ActivityArea(coordinates: [ring1])
        self.activityAreas = [area]
    }
    
}

struct PolygonMapView: UIViewRepresentable {
    var region: MKCoordinateRegion
    var polygons: [[[CLLocationCoordinate2D]]]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        
        for rings in polygons {
            for coords in rings {
                let polygon = MKPolygon(coordinates: coords, count: coords.count)
                uiView.addOverlay(polygon)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.green500.withAlphaComponent(0.3)
                renderer.strokeColor = UIColor.green500
                renderer.lineWidth = 2
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
