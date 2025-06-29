import 'package:flutter/material.dart';

class HelpPageView extends StatelessWidget {
  const HelpPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda com o Login'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Dicas para fazer login:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('- Se você esqueceu sua senha, clique em "Esqueci a Senha".'),
            SizedBox(height: 10),
            Text('- Se você ainda não tem uma conta, clique em "Cadastre-se".'),
            SizedBox(height: 10,),
            Text('- Para quaisquer outras dúvidas ou problemas, entre em contato com um dos criadores: r187635@dac.unicamp.br ou n173762@dac.unicamp.br')
          ],
        ),
      ),
    );
  }
}
