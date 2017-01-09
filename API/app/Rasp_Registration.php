<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Rasp_Registration extends Model
{

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('rasp_registration', function (Blueprint $table) {
            $table->increments('id')->unique();
            $table->string('mac_adres');
            $table->string('ip_adres');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('rasp_registration');
    }
}
