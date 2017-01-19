<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateTempsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('temps', function (Blueprint $table) {
            $table->increments('id')->unique();
            $table->string('location_id');
            $table->string('temp');
            $table->string('air');
            $table->string('device');
            $table->string('rasp_mac');
            $table->string('local_ip');
            $table->string('temp_buiten');
            $table->string('air_buiten');
            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('temps');
    }
}
