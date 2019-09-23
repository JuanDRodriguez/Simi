//
//  LegalViewController.swift
//  Supervisores
//
//  Created by Sharepoint on 5/29/19.
//  Copyright © 2019 Farmacias Similares. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var txtViewLegal: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtViewLegal.delegate = self
        self.txtViewLegal.isSelectable = true
        CommonInit.navBarGenericBack(vc: self, navigationBar: self.navBar, title: "Legal")
        
        
        let text: String = self.getString()
        let attributedText: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 0, length: 38))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 75, length: 35))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 772, length: 33))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 2461, length: 40))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 4432, length: 32))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 5198, length: 51))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 6429, length: 24))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 6520, length: 24))
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 6520, length: 24))
        attributedText.addAttribute(.link, value: "https://www.farmaciasdesimilares.com.mx", range: NSRange(location: 5368, length: 31))
        
        txtViewLegal.attributedText = attributedText
    }
    
    func getString()->String {
        return """
        1. IDENTIDAD DEL TITULAR DEL SITIO WEB Farmacias de Similares S.A. de C.V.
        
        2. CONDICIONES DE USO Y ACEPTACIÓN Las presentes Condiciones (conocidas como Aviso Legal) tienen por objeto regular el uso de la App, que su titular pone a disposición desde AppStore. La utilización de la App por un tercero le atribuye la condición de Usuario y, supone la aceptación plena por dicho Usuario, de todas y cada una de las condiciones que se incorporan en el presente Aviso Legal. El titular de la App puede ofrecer a través de la App, contenidos y/o servicios que podrán encontrarse sometidas a unas condiciones particulares propias que, según los casos, sustituyen, completan y/o modifican las presentes Condiciones, y sobre las cuales se informará al Usuario en cada caso concreto.
        
        3. USO CORRECTO DEL SITIO WEB El Usuario se compromete a utilizar la App, los contenidos y servicios de conformidad con las leyes aplicables, el presente Aviso Legal, las buenas costumbres y el orden público. Del mismo modo, el Usuario se obliga a no utilizar la App o los servicios que se presten a través de él con fines o efectos ilícitos o contrarios al contenido del presente Aviso Legal, lesivos de los intereses o derechos de terceros, o que de cualquier forma pueda dañar, inutilizar o deteriorar la App o sus servicios, o impedir un normal disfrute de la App por otros Usuarios. El uso de todos los contenidos y servicios, en su caso, se regirán por el más escrupuloso respeto a la legalidad vigente,  y demás normativa legal. No permitiéndose ningún tipo de ataque ofensivo, injurioso etc. que pueda ser objeto de una violación de derecho de cualquier persona o institución. Asimismo, el Usuario se compromete expresamente a no destruir, alterar, inutilizar o, de cualquier otra forma, dañar los datos, programas o documentos electrónicos y demás que se encuentren en la presente App. El Usuario se compromete a no obstaculizar el acceso de otros usuarios al servicio de acceso mediante el consumo masivo de los recursos informáticos a través de los cuales el titular de la App presta el servicio, así como realizar acciones que dañen, interrumpan o generen errores en dichos sistemas. El Usuario se compromete a no introducir programas, virus, macros, applets, controles ActiveX o cualquier otro dispositivo lógico o secuencia de caracteres que causen o sean susceptibles de causar cualquier tipo de alteración en los sistemas informáticos del titular de la App o de terceros.
        
        4. PROPIEDAD INTELECTUAL E INDUSTRIAL Todos los derechos de propiedad industrial e intelectual de la App, así como de los elementos contenidos en el mismo y en sus páginas web (incluidos, con carácter enunciativo que no limitativo, el diseño gráfico, código fuente, logos, contenidos, imágenes, textos, gráficos, ilustraciones, fotografías, bases de datos y demás elementos que aparecen en la App), salvo que se indique lo contrario, son titularidad exclusiva del titular de la App o recursos libres, de donde se han obtenido por su carácter publico y divulgativo de sus contenidos. En este sentido, el titular de esta App hace expresa reserva de todos los derechos. Igualmente, todos los nombres comerciales, dominios, marcas o signos distintivos de cualquier clase contenidos en la App, están protegidos por la Ley. El titular de la App no concede ningún tipo de licencia o autorización de uso público y/o comercial al Usuario sobre sus derechos de propiedad intelectual e industrial o sobre cualquier otro derecho relacionado con esta App, sus contenidos y los servicios ofrecidos en las mismas. El Usuario única y exclusivamente podrá acceder a tales elementos y servicios para uso laboral, quedando, por tanto, terminantemente prohibida la utilización de la totalidad o parte de los contenidos de esta App con propósitos públicos o comerciales, su distribución, comunicación pública, incluida la modalidad de puesta a disposición, así como su modificación, alteración o descompilación a no ser que para ello se cuente con el consentimiento expreso y por escrito del titular de la App. Por ello, el Usuario reconoce que la reproducción, distribución, comercialización, transformación, y en general, cualquier otra forma de explotación, por cualquier procedimiento, de todo o parte de los contenidos de esta App y sus páginas webs constituye una infracción de los derechos de propiedad intelectual y/o industrial del titular de la App de los titulares de los mismos.
        
        5. RÉGIMEN DE RESPONSABILIDAD
        5.1. Responsabilidad por el Uso de la App. El Usuario es el único responsable de las infracciones en las que pueda incurrir o de los perjuicios que pueda causar por la utilización de la App, quedando el titular de la App, sus socios, empresas del grupo, colaboradores, empleados y representantes, exonerados de cualquier clase de responsabilidad que se pudiera derivar por las acciones del Usuario.
        5.2. Responsabilidad por el funcionamiento de la App. El titular de la App excluye toda responsabilidad que se pudiera derivar de interferencias, omisiones, interrupciones, virus informáticos, averías telefónicas o desconexiones en el funcionamiento operativo del sistema electrónico, motivado por causas ajenas al titular de la App.
        
        6. POLÍTICA DE CONFIDENCIALIDAD Y DATOS PERSONALES. El usuario manifiesta ser sabedor del contenido del aviso de privacidad del titular de la App contenido en la página www.farmaciasdesimilares.com.mx, y asimismo  reconoce que derivado del uso de la App, podrá tener acceso a información perteneciente a las operaciones, estrategias, políticas y manejo de actividades del titular de la app o de sus filiales, empresas relacionadas, asociadas, afiliadas y franquicias y/o licenciantes; programas o sistemas de cómputo, software, programas o sistemas de cómputo, algoritmos, fórmulas, diagramas, planos, procesos, técnicas, diseños, fotografías, registros, compilaciones, y, en general, toda aquella información que esté relacionada con programas, ideas, inventos, marcas, patentes, nombres comerciales, secretos industriales y derechos de propiedad industrial o intelectual, licencias y cualquier otra información oral o escrita que  tenga acceso,  la cual será de carácter confidencial. Por lo cual el usuario por ningún motivo estará facultado para copiar, editar, reproducir por cualquier medio conocido o que en un futuro se conozca, elaborar extractos o revelar a cualquier persona física o moral, total o parcialmente, dicha información confidencial o cualquier otra que se relacione con la App y reconoce que dicha información confidencial es de la exclusiva propiedad de la titular de la App y esta tendrá derecho a exigir que en cualquier momento la misma sea destruida o devuelta.
        """
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
