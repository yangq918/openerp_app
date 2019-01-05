package org.yq.openerpapp;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.webkit.MimeTypeMap;

import java.io.File;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static Context mContext = null;
  private static final String METHOD_CHANNEL = "openFileChannel";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    mContext = this;

    new MethodChannel(getFlutterView(), METHOD_CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                if (methodCall.method.equals("openFile")) {
                  String path = methodCall.argument("path");
                  openFile(mContext, path);
                  result.success("");
                } else {
                  result.notImplemented();
                }
              }
            }
    );


  }

  private void openFile(Context context, String path) {
    try {

      File file = new File(path);
      if (!file.exists()) {
        System.out.println("the " + path + " file is not exists");
        return;
      }

      if (!path.contains("file://")) {
        path = "file://" + path;
      }


      String[] nameType = path.split("\\.");
      String type="";
      if(null!=nameType)
      {
        type = nameType[nameType.length-1];
      }

      String mimeType = MimeTypeMap.getSingleton().getMimeTypeFromExtension(type);
      System.out.print(mimeType);
      if(null==mimeType||mimeType.length()<=0)
      {
        Intent intent = showOpenTypeDialog(path);
        context.startActivity(Intent.createChooser(intent, "请选择对应的软件打开该文件！"));
        ;
      }
      else
      {
        starActive(context, path, mimeType);
      }




    } catch (Exception e) {
      System.out.println(e);
    }
  }

  private void starActive(Context context, String path, String mimeType) {
    Intent intent = new Intent(Intent.ACTION_VIEW);
    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.addCategory("android.intent.category.DEFAULT");
    intent.setDataAndType(Uri.parse(path), mimeType);

    context.startActivity(intent);
  }

  private  Intent showOpenTypeDialog(String param) {
    Intent intent = new Intent();
    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
    intent.setAction(android.content.Intent.ACTION_VIEW);

    Uri uri = Uri.parse(param);
    intent.setDataAndType(uri, "*/*");
    return intent;
  }

}
