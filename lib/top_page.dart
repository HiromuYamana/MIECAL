import 'package:flutter/material.dart';
import 'package:miecal/login.dart';
import 'package:miecal/vertical_slide_page.dart';

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class RippledEffect extends StatefulWidget{
  final double size;
  final Color color;

  const RippledEffect({super.key, this.size = 100,this.color = Colors.blue});

  @override
  _RippleEffectState createState() => _RippleEffectState();
} 

class _RippleEffectState extends State<RippledEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      )..repeat();

      _animation = Tween(begin:0.0,end:widget.size).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),

      );
  }
  @override
  void dispose(){
  _controller.dispose();
  super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: _animation.value,
            height: _animation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: 1 - _animation.value / widget.size),
            ),
          ),
        );
      },
    );
  }
}



class _TopPageState extends State<TopPage> {
  void _goToLoginPage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context,animation,secondaryAnimation) => LoginPage(),
        transitionsBuilder: (context,animation,secondaryAnimation,child){
          const begin =Offset(0.0,1.0);
          const end =Offset.zero;
          const curve =Curves.ease;

          final tween = Tween(begin: begin,end:end).chain(CurveTween(curve:curve));
          final slideAnimation =animation.drive(tween);

          return SlideTransition(
            position: slideAnimation,
            child: child,
            );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        
        onTap: _goToLoginPage,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.5,
              colors: [
                Colors.blue,
                Color(0xFF80D6FF),
              ]
            
          )),
          child:  Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [Image.asset('assets/app_icon.png',
                          width: 350,
                          height: 350,),
                          SizedBox(height: 150,)]
                ),),),
                
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children:[SizedBox(height: 500,),
                  RippledEffect()
                  ]
                ),
                
                Positioned(
                  bottom: 0,
                  right: 0,
                  left:0,
                  top: 200,
                  child:Align(
                    alignment: Alignment(0.0, 1.25),
                    child:Image.asset("assets/タッチアイコン.png",width: 100,)
                  )
                ),
                  
               ]
              ),           
            ]
          ),
        ),
      ),
    ));
  }
}
