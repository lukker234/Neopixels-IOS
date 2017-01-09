<?php

use App\Permission;
use Illuminate\Database\Seeder;

class PermissionsTableSeeder extends Seeder
{
    public function run()
    {
        $showAll = new Permission();
        $showAll->name          = 'Show-All';
        $showAll->display_name  = 'Show All Data';
        $showAll->description   = 'User can see all data';
        $showAll->save();
        
        $postData = new Permission();
        $postData->name          = 'Post_data_to_db';
        $postData->display_name  = 'Post data to db';
        $postData->description   = 'Post data to db from app';
        $postData->save();
    }
}
