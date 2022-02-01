package app.pandasaver

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.content.Intent.FLAG_ACTIVITY_CLEAR_TOP

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
                this.finishAffinity();
        if (intent.getIntExtra("org.chromium.chrome.extra.TASK_ID", -1) == this.taskId) {
                this.startActivity(intent);
              
        }
        super.onCreate(savedInstanceState)
    }
}